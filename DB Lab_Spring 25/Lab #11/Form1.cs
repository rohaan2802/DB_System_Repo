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

namespace i222327_Lab11
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void label5_Click(object sender, EventArgs e)
        {

        }

        private void label3_Click(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox4_TextChanged(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            // Define the connection string (update with your details)
            string connectionString = "Data Source=CODE-TECH\\SQLEXPRESS;Initial Catalog=LAB11;Integrated Security=True";

            // Create the SQL connection
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                try
                {
                    // Open connection
                    con.Open();

                    // Prepare the INSERT query
                    string query = "INSERT INTO CREDENTIALS (FIRSTNAME, LASTNAME, EMAIL, PASSWORD) " +
                                               "VALUES (@FirstName, @LastName, @Email, @Password)";
                    // Create SqlCommand and pass values
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        // Assume you have 4 textboxes: txtFirstName, txtLastName, txtEmail, txtPassword
                        cmd.Parameters.AddWithValue("@FirstName", textBox1.Text);
                        cmd.Parameters.AddWithValue("@LastName", textBox2.Text);
                        cmd.Parameters.AddWithValue("@Email", textBox3.Text);
                        cmd.Parameters.AddWithValue("@Password", textBox4.Text);

                        // Execute the command
                        int result = cmd.ExecuteNonQuery();

                        // Check if insertion was successful
                        if (result > 0)
                        {
                            MessageBox.Show("Record inserted successfully!");
                        }
                        else
                        {
                            MessageBox.Show("Insertion failed.");
                        }
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Error: " + ex.Message);
                }
            }
        }

        private void linkLabel1_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            // Create and show the login form
            Form2 login = new Form2();
            login.Show();

            // Optionally hide the current register form
            this.Hide();
        }

    }
}
