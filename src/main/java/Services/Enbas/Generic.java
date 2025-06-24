package Services.Enbas;

import static Services.logic.AuthenticationService.isAccessToken;
import static Services.logic.AuthenticationService.isValidToken;
import jakarta.ws.rs.HeaderParam;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;

@Path("/services")
public class Generic {

    static boolean isOtpAuthenticated = false;
    static boolean isAuthenticated = false;
    @POST
    @Path("/generic")
    @Produces(MediaType.APPLICATION_JSON)
    public Response generic(@HeaderParam("Authorization") String authorizationHeader) {
        if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
            return Response.status(Response.Status.UNAUTHORIZED).entity("Missing or invalid Authorization header").build();
        }

        String token = authorizationHeader.substring("Bearer".length()).trim();

        if (isValidToken(token)) {
            if (isAccessToken(token)) {
                isAuthenticated = true;
                return Response.ok().entity("Authenticated!").build();
            } else {
                isAuthenticated = false;
                return Response.status(Response.Status.UNAUTHORIZED).entity("Invalid Token").build();
            }
        } else {
            isAuthenticated = false;
            return Response.status(Response.Status.UNAUTHORIZED).entity("Invalid Token").build();
        }
    }
//    
//    @POST
//    @Path("/otp/generateotp")
//    @Produces(MediaType.APPLICATION_JSON)
//    public Response generateOtp(
//            @QueryParam("email") String email,
//            @QueryParam("clientId") String clientId) {
//
//        try {
//            AuthenticationService.sendEmail(email, clientId);
//            return Response.ok().entity("email successfully sent").build();
//        } catch (MailjetException e) {
//            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity("Failed to send email").build();
//        }
//    }
//
//    @POST
//    @Path("/otp/verifyotp")
//    @Produces(MediaType.APPLICATION_JSON)
//    public Response verifyOtp(@QueryParam("clientId") String clientId, @QueryParam("email") String email, @QueryParam("otp") String otp) {
//        boolean otpVerificationResult = AuthenticationService.verifyOtp(clientId, email, otp);
//        if (otpVerificationResult) {
//            return Response.ok().entity("OTP successfully verified").build();
//        } else {
//            return Response.status(Response.Status.BAD_REQUEST).entity("Invalid or Expired OTP code").build();
//        }
//
//    }
//
//    @POST
//    @Path("/otp/generateotpnumber")
//    @Produces(MediaType.APPLICATION_JSON)
//    public Response generateOtpNumber(
//            @QueryParam("phoneNumber") String phoneNumber,
//            @QueryParam("clientId") String clientId) {
//
//        try {
//            AuthenticationService.sendSms(phoneNumber, clientId);
//            return Response.ok().entity("OTP successfully sent via SMS").build();
//        } catch (Exception e) {
//            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity("Failed to send OTP via SMS").build();
//        }
//    }
//
//    @POST
//    @Path("/otp/verifyotpnumber")
//    @Produces(MediaType.APPLICATION_JSON)
//    public Response verifyOtpNumber(@QueryParam("clientId") String clientId, @QueryParam("phoneNumber") String phoneNumber, @QueryParam("otp") String otp) {
//        boolean otpVerificationResult = AuthenticationService.verifyOtpNumber(clientId, phoneNumber, otp);
//        if (otpVerificationResult) {
//            return Response.ok().entity("OTP successfully verified via SMS").build();
//        } else {
//            return Response.status(Response.Status.BAD_REQUEST).entity("Invalid or Expired OTP code").build();
//        }
//    }
}
