package Services.Filter;

import Services.logic.AuthenticationService;
import static Services.logic.AuthenticationService.CLIENT_SECRET;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.SignatureException;
import jakarta.annotation.Priority;
import jakarta.ws.rs.Priorities;
import jakarta.ws.rs.container.ContainerRequestContext;
import jakarta.ws.rs.container.ContainerRequestFilter;
import jakarta.ws.rs.container.ResourceInfo;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.ext.Provider;

import java.lang.reflect.Method;

@Secured
@Provider
@Priority(Priorities.AUTHENTICATION)
public class JWTAuthenticationFilter implements ContainerRequestFilter {

    @Context
    private ResourceInfo resourceInfo;

    @Override
    public void filter(ContainerRequestContext requestContext) {
        Method method = resourceInfo.getResourceMethod();

        if (method != null && (method.isAnnotationPresent(Secured.class)
                || resourceInfo.getResourceClass().isAnnotationPresent(Secured.class))) {

            String authHeader = requestContext.getHeaderString("Authorization");

            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                abort(requestContext, "Token mancante o formato errato");
                return;
            }

            String token = authHeader.substring("Bearer".length()).trim();

            try {
                if (AuthenticationService.isValidToken(token)
                        && AuthenticationService.isAccessToken(token)) {

                    Claims claims = Jwts.parser()
                            .setSigningKey(CLIENT_SECRET.getBytes())
                            .parseClaimsJws(token)
                            .getBody();

                    String username = claims.getSubject();
                    int ruolo = claims.get("ruolo", Integer.class);

                    requestContext.setProperty("username", username);
                    requestContext.setProperty("ruolo", ruolo);

                    RolesAllowedCustom rolesAnnotation = method.getAnnotation(RolesAllowedCustom.class);
                    if (rolesAnnotation == null) {
                        rolesAnnotation = resourceInfo.getResourceClass().getAnnotation(RolesAllowedCustom.class);
                    }

                    if (rolesAnnotation != null) {
                        boolean autorizzato = false;
                        for (int r : rolesAnnotation.value()) {
                            if (r == ruolo) {
                                autorizzato = true;
                                break;
                            }
                        }

                        if (!autorizzato) {
                            abort(requestContext, "Accesso negato: ruolo insufficiente");
                        }
                    }

                } else {
                    abort(requestContext, "Token non valido");
                }

            } catch (SignatureException | io.jsonwebtoken.ExpiredJwtException e) {
                abort(requestContext, "Token non valido o scaduto");
                e.printStackTrace();
            } catch (Exception e) {
                abort(requestContext, "Errore durante la validazione del token");
                e.printStackTrace();
            }
        }
    }

    private void abort(ContainerRequestContext requestContext, String message) {
        requestContext.abortWith(
                Response.status(Response.Status.UNAUTHORIZED)
                        .entity("{\"error\": \"" + message + "\"}")
                        .build());
    }
}
