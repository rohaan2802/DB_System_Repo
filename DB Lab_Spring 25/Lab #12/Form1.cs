using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;
using Microsoft.Reporting.WinForms;


namespace i222327_Lab_12
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();

        }

        private void Form1_Load(object sender, EventArgs e)
        {
            // TODO: This line of code loads data into the 'lab12DataSet.User' table. You can move, or remove it, as needed.
          //  this.userTableAdapter.Fill(this.lab12DataSet.User);
            // TODO: This line of code loads data into the 'lab12DataSet.User' table. You can move, or remove it, as needed.
            //     this.userTableAdapter.Fill(this.lab12DataSet.User);
            // TODO: This line of code loads data into the 'lab12DataSet1.User_Table' table. You can move, or remove it, as needed.
            //   this.Fill(this.lab12DataSet1.User_Table);

            this.BeginInvoke(new Action(() =>
            {
                textBox3.Focus();
            }));
              this.reportViewer1.RefreshReport();
            this.reportViewer1.RefreshReport();
            this.reportViewer1.RefreshReport();
        }


        private void button1_Click(object sender, EventArgs e)
        {
            // Read data from text boxes
            string idText = textBox3.Text.Trim();      // UserID
            string userName = textBox1.Text.Trim();    // UserName
            string userPassword = textBox2.Text.Trim(); // UserPassword
            string gender = comboBox1.SelectedItem?.ToString(); // Gender

            // Basic input validation
            if (string.IsNullOrWhiteSpace(idText) ||
                string.IsNullOrWhiteSpace(userName) ||
                string.IsNullOrWhiteSpace(userPassword) ||
                string.IsNullOrWhiteSpace(gender))
            {
                MessageBox.Show("Please fill in all fields.");
                return;
            }

            // Validate that UserID is numeric
            if (!int.TryParse(idText, out int userId))
            {
                MessageBox.Show("User ID must be a number.");
                return;
            }

            // Define SQL connection and insert command
            string connectionString = "Server=CODE-TECH\\SQLEXPRESS;Database=Lab12;Trusted_Connection=True;";
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "INSERT INTO User_Table (UserID, UserName, UserPassword, Gender) VALUES (@UserID, @UserName, @UserPassword, @Gender)";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    // Add parameters
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    cmd.Parameters.AddWithValue("@UserName", userName);
                    cmd.Parameters.AddWithValue("@UserPassword", userPassword);
                    cmd.Parameters.AddWithValue("@Gender", gender);

                    try
                    {
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        MessageBox.Show("User inserted successfully!");
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show("Error: " + ex.Message);
                    }
                }
            }
        }

        private void textBox3_TextChanged(object sender, EventArgs e)
        {

        }

        private void button3_Click(object sender, EventArgs e)
        {
            // Read data from form fields
            string idText = textBox3.Text.Trim();      // UserID
            string name = textBox1.Text.Trim();        // New Name
            string password = textBox2.Text.Trim();    // New Password
            string gender = comboBox1.SelectedItem?.ToString(); // New Gender

            // Validate input
            if (string.IsNullOrWhiteSpace(idText) ||
                string.IsNullOrWhiteSpace(name) ||
                string.IsNullOrWhiteSpace(password) ||
                string.IsNullOrWhiteSpace(gender))
            {
                MessageBox.Show("Please fill in all fields.");
                return;
            }

            // Validate numeric UserID
            if (!int.TryParse(idText, out int userId))
            {
                MessageBox.Show("User ID must be a number.");
                return;
            }

            // Connection string
            string connectionString = "Server=CODE-TECH\\SQLEXPRESS;Database=Lab12;Trusted_Connection=True;";
            string query = "UPDATE User_Table SET UserName = @UserName, UserPassword = @UserPassword, Gender = @Gender WHERE UserID = @UserID";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    // Set parameters
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    cmd.Parameters.AddWithValue("@UserName", name);           // Update UserName column
                    cmd.Parameters.AddWithValue("@UserPassword", password);  // Update UserPassword column
                    cmd.Parameters.AddWithValue("@Gender", gender);          // Update Gender column

                    try
                    {
                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            MessageBox.Show("User updated successfully!");
                        }
                        else
                        {
                            MessageBox.Show("No user found with that ID.");
                        }
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show("Error: " + ex.Message);
                    }
                }
            }
        }


        private void button4_Click(object sender, EventArgs e)
        {
            string idText = textBox3.Text.Trim();  // Get UserID from textBox3

            // Validate that UserID is entered
            if (string.IsNullOrWhiteSpace(idText))
            {
                MessageBox.Show("Please enter a User ID to delete.");
                return;
            }

            // Validate that UserID is numeric
            if (!int.TryParse(idText, out int userId))
            {
                MessageBox.Show("User ID must be a valid number.");
                return;
            }

            // Define the SQL connection and DELETE command
            string connectionString = "Server=CODE-TECH\\SQLEXPRESS;Database=Lab12;Trusted_Connection=True;";
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM User_Table WHERE UserID = @UserID";  // Use User_Table instead of User
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    // Add parameter for UserID
                    cmd.Parameters.AddWithValue("@UserID", userId);

                    try
                    {
                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            MessageBox.Show("User deleted successfully!");
                        }
                        else
                        {
                            MessageBox.Show("No user found with the given ID.");
                        }
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show("Error: " + ex.Message);
                    }
                }
            }
        }


            private void button2_Click(object sender, EventArgs e)
            {
                string connectionString = "Server=CODE-TECH\\SQLEXPRESS;Database=Lab12;Trusted_Connection=True;";
                string query = "SELECT * FROM User_Table"; // Updated table name to User_Table

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        try
                        {
                            conn.Open();
                            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                            DataTable dt = new DataTable();
                            adapter.Fill(dt);

                            if (dt.Rows.Count == 0)
                            {
                                MessageBox.Show("No data found.");
                                return;
                            }

                            // Set the DataSource to the DataTable, and ensure the DataGridView is visible
                            dataGridView1.DataSource = dt;
                            dataGridView1.Visible = true; // Make the DataGridView visible when data is loaded

                            // Optionally, auto-size the columns for better display
                            dataGridView1.AutoResizeColumns();
                        }
                        catch (Exception ex)
                        {
                            MessageBox.Show("Error: " + ex.Message);
                        }
                    }
                }
            }



        private void button5_Click(object sender, EventArgs e)
        {
            button5.Visible = false; // Hide the button after data is loaded
            dataGridView1.Visible = false; // Show grid only after data is loaded

        }

        private void button6_Click(object sender, EventArgs e)
        {
            button7.Visible = true;
            // Connection string for the database
            string connectionString = "Server=CODE-TECH\\SQLEXPRESS;Database=Lab12;Trusted_Connection=True;";
            reportViewer1.Visible = true;
            // SQL query to fetch data for the report
            string query = "SELECT UserID, UserName, UserPassword, Gender FROM User_Table";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    try
                    {
                        // Open the connection to the database
                        conn.Open();

                        // Use a DataAdapter to fill a DataTable
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);

                        // Create a report data source and set it to the ReportViewer
                        ReportDataSource reportDataSource = new ReportDataSource("DataSet1", dt);
                        reportViewer1.LocalReport.DataSources.Clear(); // Clear existing data sources
                        reportViewer1.LocalReport.DataSources.Add(reportDataSource);

                        // Set the path to the RDLC file (ensure the file is added to your project)
                        reportViewer1.LocalReport.ReportPath = "Report1.rdlc"; // Path to your report file

                        // Refresh the ReportViewer to display the report
                         reportViewer1.RefreshReport();
                    }
                    catch (Exception ex)
                    {
                        // Display an error message if the query fails
                        MessageBox.Show("Error: " + ex.Message);
                    }
                }
            }
        }

        private void reportViewer1_Leave(object sender, EventArgs e)
        {
            reportViewer1.Visible = false;
        }

        private void reportViewer1_Load(object sender, EventArgs e)
        {

        }

        private void reportViewer1_Load_1(object sender, EventArgs e)
        {

        }

        private void button7_Click(object sender, EventArgs e)
        {
            reportViewer1.Visible = false;
            button7.Visible = false; // Hide the button after data is loaded
        }
    }
}
