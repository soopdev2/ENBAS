/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet.Utente;

import Entity.Utente;
import Utils.JPAUtil;
import Utils.Utils;
import static Utils.Utils.estraiEccezione;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 * @author Salvatore
 */
public class Login extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        boolean isLogin = Boolean.parseBoolean(request.getParameter("isLogin"));
        final Logger LOGGER = LoggerFactory.getLogger(Login.class.getName());
        try {
            if (isLogin) {
                Login(request, response, LOGGER);
            } else {
                Logout(request, response, LOGGER);
            }
        } catch (ServletException | IOException e) {
            LOGGER.error("Non è stato possibile effettuare l'operazione (login/logout). " + "\n" + estraiEccezione(e));
        }
    }

    protected void Login(HttpServletRequest request, HttpServletResponse response, Logger LOGGER)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        JPAUtil jPAUtil = new JPAUtil();
        if (jPAUtil.isPasswordValid(username, password)) {
            int roleId = jPAUtil.authenticate(username, password);
            if (roleId != -1) {
                Utente user = jPAUtil.getUserByUsername(username);
                if (request.getContextPath().contains("gestionale_questionario")) {
                    request.getSession().setAttribute("src", "../..");
                }

                if (user != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("userId", user.getId());
                    String userIdParam = Utils.checkAttribute(session, "userId");
                    int userId = Utils.tryParseInt(userIdParam);
                    session.setAttribute("username", user.getUsername());
                    session.setAttribute("user", user);

                    LOGGER.info(user.getNome() + " " + user.getCognome() + " " + "Ha effettuato con successo il Login!" + " in data:"
                            + new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new Date()));
                    redirectToPageByRole(response, request, userId, roleId);

                } else {
                    response.sendRedirect("index.jsp?esito=KO2&codice=000");
                }
            } else {
                response.sendRedirect("index.jsp?esito=KO3&codice=000");
            }
        } else {
            response.sendRedirect("index.jsp?esito=KO&codice=000");
        }
    }

    private void redirectToPageByRole(HttpServletResponse response, HttpServletRequest request, int userId, int roleId) throws IOException {
        String targetPage;

        switch (roleId) {
            case 1:
                targetPage = "AD_homepage.jsp";
                break;
            case 2:
                targetPage = "US_homepage.jsp";
                break;
            default:
                targetPage = "";
                break;
        }

        if (!targetPage.isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("userId", userId);

            response.sendRedirect(response.encodeRedirectURL(targetPage));
        } else {
            response.sendRedirect("index.jsp?esito=KO");
        }
    }

    protected void Logout(HttpServletRequest request, HttpServletResponse response, Logger LOGGER)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        try {
            JPAUtil jPAUtil = new JPAUtil();
            HttpSession session = request.getSession();
            String userIdParam = Utils.checkAttribute(session, "userId");
            Utente user = jPAUtil.findUserByUserId(userIdParam);
            LOGGER.info(user.getNome() + " " + user.getCognome() + " " + "Ha effettuato con successo il Logout!" + " in data:"
                    + new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new Date()));
            session.invalidate();
        } catch (Exception e) {
            LOGGER.error("Non è stato possibile effettuare il logout. " + "\n" + estraiEccezione(e));
        }
        response.sendRedirect("index.jsp?esito=OK&codice=000&logout=true");

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
