import javafx.application.Application;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.*;
import javafx.scene.text.*;
import javafx.geometry.*;    
import javafx.event.ActionEvent;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.CallableStatement;

public class WithdrawFromSection extends Application
{
    private Label     studentLabel;
    private TextField studentField;
    private Label     sectionLabel;
    private TextField sectionField;
    private Label     dateLabel;
    private TextField dateField;
    private Button    withdrawButton;
    private Label     statusLabel;

    @Override
    public void start(Stage primaryStage)
    {
        primaryStage.setTitle("Withdraw Student From Section");

        studentField = new TextField();
        studentField.setPrefWidth(110);
        sectionField = new TextField();
        sectionField.setPrefWidth(110);
        dateField    = new TextField();
        dateField.setPrefWidth(110);

        studentLabel = new Label("Student Id:");
        sectionLabel = new Label("Section Id:");
        dateLabel    = new Label("Withdrawal Date (yyyy‑mm‑dd):");

        withdrawButton = new Button("Withdraw");
        withdrawButton.setOnAction(this::eventHandler);

        statusLabel = new Label("Fill in all fields then click the button");

        GridPane mainPane = new GridPane();
        mainPane.setAlignment(Pos.CENTER);

        mainPane.add(studentLabel,   0, 0, 1, 1);
        mainPane.add(studentField,   1, 0, 1, 1);
        mainPane.add(sectionLabel,   0, 1, 1, 1);
        mainPane.add(sectionField,   1, 1, 1, 1);
        mainPane.add(dateLabel,      0, 2, 1, 1);
        mainPane.add(dateField,      1, 2, 1, 1);
        mainPane.add(withdrawButton, 0, 3, 1, 1);
        mainPane.add(statusLabel,    0, 4, 2, 1);

        mainPane.setHgap(12);
        mainPane.setVgap(12);

        Scene scene = new Scene(mainPane, 620, 520);
        primaryStage.setScene(scene);
        primaryStage.show();
    }

  
    public void eventHandler(ActionEvent event)
    {
        
        int studentId, sectionId;
        String withdrawDate; 
        try
        {
            studentId = Integer.parseInt(studentField.getText());
            sectionId = Integer.parseInt(sectionField.getText());
        }
        catch (Exception e)
        {
            statusLabel.setText("Improper numeric entry");
            return;
        }

        try
        {
            
            Connection connector = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/unbcourse",  
                "root",                                   
                "YOUR_PASSWORD"                           
            );

         
            String call = "{CALL withdrawFromSection(?,?,?)}";

            CallableStatement procedureCall = connector.prepareCall(call);
            procedureCall.setInt(1, studentId);
            procedureCall.setInt(2, sectionId);
            procedureCall.setString(3, dateField.getText());

            int affectedRows = procedureCall.executeUpdate();
            if (affectedRows == 0)
                statusLabel.setText("Withdrawal failed");
            else
                statusLabel.setText("Withdrawal succeeded");

            connector.close();
        }
        catch (SQLException e)
        {
            statusLabel.setText("Database error: " + e.getMessage());
        }
    }

}
