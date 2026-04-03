import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;
import java.util.InputMismatchException;

/** Text-based JDBC program to display all students in a given section. */
public class ClassList2 
{

    public static void main(String[] args) 
    {
        Connection connector = openConnection();
        if (connector == null) 
        {
            System.err.println("Unable to connectorect to the database");
            System.exit(1);
        }

        PreparedStatement sectionStatement = prepareSectionStatement(connector);
        PreparedStatement rosterStmt  = prepareRosterStatement(connector);

        char command = getCommand();
        while (command != 'q')
        {
            if (command == 'c') 
            {
                displayClassList(sectionStatement, rosterStmt);
            } 
            else 
            {
                System.out.println("Invalid command");
            }
            command = getCommand();
        }

        closeConnection(connector);
    }

    private static char getCommand() 
    {
        Scanner scan = new Scanner(System.in);
        System.out.print("\n(c)lass list or (q)uit? ");
        String input = scan.nextLine().toLowerCase();
        if (input.length() > 0)
            return input.charAt(0);
        else
            return ' ';
    }

    private static Connection openConnection() 
    {
        final String url      = "jdbc:mysql://localhost:3306/unbcourse";
        final String user     = "root";
        final String password = "YourPassWord";

        Connection connector = null;
        try 
        {
            connector = DriverManager.getConnection(url, user, password);
        } 
        catch (Exception e) 
        {
            System.err.println("Couldn't open a connectorection: " + e.getMessage());
        }
        return connector;
    }

    private static void closeConnection(Connection connector) 
    {
        try 
        {
            connector.close();
        } 
        catch (SQLException e)
        
        {
            System.err.println("Couldn't close connectorection: " + e.getMessage());
        }
    }

    private static PreparedStatement prepareSectionStatement(Connection connector) 
    {
        PreparedStatement stmt = null;
        try 
        {
            String sql = "SELECT subject_code, course_number, term_code " +
                         "FROM section WHERE section_id = ?";
            stmt = connector.prepareStatement(sql);
        } catch (SQLException e) 
        {
            System.err.println("Couldn't prepare section query: " + e.getMessage());
        }
        return stmt;
    }

    private static PreparedStatement prepareRosterStatement(Connection connector) 
    {
        PreparedStatement stmt = null;
        try
        {
            String sql = "SELECT s.email, CONCAT(s.surname, ', ', s.given_name) AS fullname, " +
                         "r.student_id, r.grade " +
                         "FROM registration r JOIN student s ON r.student_id = s.student_id " +
                         "WHERE r.section_id = ? " +
                         "ORDER BY s.surname, s.given_name";
            stmt = connector.prepareStatement(sql);
        }
        catch (SQLException e) 
        {
            System.err.println("Couldn't prepare roster query: " + e.getMessage());
        }
        return stmt;
    }

    private static void displayClassList(PreparedStatement sectStmt,
                                         PreparedStatement rosterStmt) {
        System.out.print("\nEnter the section id: ");
        int sectionId = getIdFromUser();
        int count = 0;

        try {
            // Header query
            sectStmt.setInt(1, sectionId);
            ResultSet rsSec = sectStmt.executeQuery();
            if (!rsSec.next()) {
                System.out.println("*** Section not found ***");
                return;
            }
            System.out.printf("\nSECTION: %s %s %s\n",
                              rsSec.getString("subject_code"),
                              rsSec.getString("course_number"),
                              rsSec.getString("term_code"));

            // Roster query
            rosterStmt.setInt(1, sectionId);
            ResultSet rs = rosterStmt.executeQuery();
            while (rs.next()) 
            {
                if (count == 0) 
                {
                    System.out.println("================================================================");
                    System.out.printf("%-26s %-30s %8s %5s\n",
                                      "UNB Email", "Student Name", "Student Id", "Grade");
                    System.out.println("================================================================");
                }
                count++;
                String email = rs.getString("email");
                String name  = rs.getString("fullname");
                int sid      = rs.getInt("student_id");
                String grade = rs.getString("grade");

                System.out.printf("%-26s %-30s %8d %-5s\n",
                                  email, name, sid,
                                  grade != null ? grade : "");
            }

            if (count > 0) {
                System.out.println("================================================================");
            } else {
                System.out.println("*** No registrations found for this section ***");
            }
        } catch (SQLException e) {
            System.err.println("Couldn't execute database query: " + e.getMessage());
        }
    }

    private static int getIdFromUser() 
    {
        Scanner scan = new Scanner(System.in);
        boolean success = false;
        int id = 0;
        while (!success)
        {
            try 
            {
                id = scan.nextInt();
                success = true;
            } 
            catch (InputMismatchException e) 
            {
                System.err.println("Id value must be numeric -- please try again");
            }
            scan.nextLine();
        }
        return id;
    }
}
