import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Scanner;

public class ClassList {

    public static void main(String[] args) throws Exception {
        // 1) Open connection
        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/unbcourse", "root", "YOUR_PASSWORD_HERE"
        );

        // 2) Prepare statements
        PreparedStatement sectionStmt = conn.prepareStatement(
            "SELECT subject_code, course_number, term_code " +
            "FROM section WHERE section_id = ?"
        );

        PreparedStatement rosterStmt = conn.prepareStatement(
            "SELECT s.email, CONCAT(s.surname, ', ', s.given_name) AS fullname, " +
            "r.student_id, r.grade " +
            "FROM registration r JOIN student s ON r.student_id = s.student_id " +
            "WHERE r.section_id = ? " +
            "ORDER BY s.surname, s.given_name"
        );

        // 3) Main loop
        Scanner scan = new Scanner(System.in);
        char cmd;
        do {
            System.out.print("\n(c)lass list or (q)uit? ");
            cmd = scan.nextLine().trim().toLowerCase().charAt(0);

            if (cmd == 'c') {
                System.out.print("Enter the section id: ");
                int sectionId = Integer.parseInt(scan.nextLine());

                // Section header and roster only if section exists
                sectionStmt.setInt(1, sectionId);
                ResultSet rsSec = sectionStmt.executeQuery();

                if (!rsSec.next()) {
                    System.out.println("*** Section not found ***");
                } else {
                    System.out.printf("\nSECTION: %s %s %s\n",
                                      rsSec.getString("subject_code"),
                                      rsSec.getString("course_number"),
                                      rsSec.getString("term_code")
                    );

                    // Roster details
                    rosterStmt.setInt(1, sectionId);
                    ResultSet rs = rosterStmt.executeQuery();
                    int count = 0;

                    while (rs.next()) {
                        if (count == 0) {
                            System.out.println("================================================================");
                            System.out.printf("%-26s %-30s %8s %5s\n",
                                              "UNB Email", "Student Name", "Student Id", "Grade");
                            System.out.println("================================================================");
                        }
                        count++;

                        String email = rs.getString("email");
                        String name  = rs.getString("fullname");
                        int sid       = rs.getInt("student_id");
                        String grade  = rs.getString("grade");

                        System.out.printf("%-26s %-30s %8d %-5s\n",
                                          email, name, sid,
                                          grade != null ? grade : "");
                    }

                    if (count > 0) {
                        System.out.println("================================================================");
                    } else {
                        System.out.println("*** No registrations found for this section ***");
                    }
                }
            }
        } while (cmd != 'q');

        // 4) Cleanup
        conn.close();
    }
}
