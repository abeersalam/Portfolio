using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using Encryption;
using Microsoft.Office.Interop.Word;
using System.Security.Cryptography;

/*************************************************************************************************************** 
 * Version 0.1
 *
 * CHANGES: 
 * - Aali - 9/26/2014 7:36 PM
 *      Adding an option for Word documents, be sure to do this or else it won't compile:
 *       Note: Microsoft Word needs to be Installed so I cant't test further until class
 *       1) Project -> Add Reference -> .NET -> Microsoft.Office.Interop.Word (version 14)
 *      Changed class names to CSFile and CSDocument to prevent imported library collisions
 * 
 * - Aali - 10/1/2014 11:20 PM
 *      Adding an option for images, be sure to do this or else it won't compile:
 *       1) Project -> Add Reference -> .NET -> System.Drawing (version 4)
 *      Added more documentation
 *      Started image implementation
 * 
 *  - Kyle - 10/7/2014 8:17 PM
 * 
 *    Added encryption method #3
 *    1) Goto https://gist.github.com/jbtule/4336842/ download source code.
 *    2) Add AESThenHMAC.cs into the project
 *   
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 ***************************************************************************************************************/


/*************************************************************************************************************** 
 * Version 0.1
 * 
 * TO DO:
 *  Aali - Excel spreadsheet, BMP image
 *  
 *  Jarid - 
 *  
 *  Kyle - 
 *  
 *  Abeer -  
 * 
 ***************************************************************************************************************/

namespace Cryptik
{
    /******************************************
     * Base Abstract Class CSFile
     *  
     * All methods and variables inherited by:
     *  - CSDocument
     *  - CSImage
     *****************************************/

    public abstract class CSFile
    {
        protected string filename;
        protected string extension;
        protected string key;
        protected byte[] authKey;
        protected byte[] aesKey;

        public virtual void import(string _filename)
        {
        }

        public virtual void encrypt(int encryptionType)
        {
        }

        public virtual void decrypt(int encryptionType)
        {
        }

        public virtual void export()
        {
        }

        public virtual void setKey(string _key)
        {
        }

        public virtual void print()
        {
        }
       
    }

    /******************************************
     * End of CSFile class
     *****************************************/

    /******************************************
     * Public Derived Class CSDocument
     * 
     * Inherits all methods and variables from CSFile
     * 
     * private:
     *  StringBuilder text
     * 
     * public:
     *  import
     *  encrypt
     *  decrypt
     *  export
     *  setKey
     *  print
     *****************************************/

    internal class CSDocument : CSFile
    {
        /******************************************
         * Private Variables specific to this class
         ******************************************/
        private StringBuilder text;

        /******************************************
         * Public Methods
         *****************************************/

        /******************************************
         * Constructor - Initialize all inherited
         *  private variables and initialize
         *  local private variable
         *****************************************/

        public CSDocument()
        {
            text = null;
            filename = extension = key = null;
        }

        /******************************************
         * Import - Import file by _filename, method
         *  automatically handles name & file extension.
         *  
         * Initialize private variable:
         *  - filename (inherited)
         *  - extension (inherited)
         *  - text (local)
         *   
         * Encrypts following file formats:
         *  1) Text file
         *  2) Word documents
         *  3) Excel spreadsheets
         *  4) Invalid filetypes (.rtf, .odt, etc)
         *   
         * Jarid will handle passing the filename
         *  through the GUI
         *****************************************/

        public override void import(string _filename)
        {
            string[] file_ext = _filename.Split('.');
            filename = file_ext[0];
            extension = file_ext[1];

            if (extension == "txt")
            {
                // .txt file
                StreamReader sr = new StreamReader(_filename);
                string fileInput = sr.ReadToEnd();
                text = new StringBuilder(fileInput);
            }
            else if (extension == "doc" || extension == "docx")
            {
                // word documents
                Application application = new Application();
                Document document = application.Documents.Open(_filename);
                string[] fileInput = new string[document.Words.Count];

                Console.WriteLine("DONE");
                for (int i = 1; i <= document.Words.Count; i++)
                {
                    fileInput[i - 1] = document.Words[i].Text;
                }
                Console.WriteLine("DONE");

                text = new StringBuilder(String.Join(" ", fileInput));
                ((_Application) application).Quit();
            }
            else if (extension == "xls" || extension == "xlsx")
            {   
                
                // MAYBE: Excel spreadsheets
            }
            else
            {
                //throw invalid format
            }
        }

        /******************************************
         * Encrypt - Encrypts algorithms based on given
         *  encryptionType by the user
         *  
         * Encryption Type:
         *  1) Vigenere XOR encryption:
         *   Simple encryption technique that iterates
         *   through each character in the file and each
         *   character in a user entered key and encrypts
         *   it by adding the two ASCII values and an XOR
         *   -> (Key[i] + text[i]) ^ key[i]  = text[i]
         *      (  A    +   g    ) ^   g     = Ï
         *      (  65   +   103  ) ^   103   = 207
         *****************************************/

        public override void encrypt(int encryptionType)
        {
            if (encryptionType == 1)
            {
                // Encryption Algorithm #1: Vigenere XOR
                for (int i = 0; i < text.Length; i++)
                {
                    text[i] = (char) ((key[i%key.Length] + text[i]) ^ key[i%key.Length]);
                }

            }
            else if (encryptionType == 2)
            {
                //abeer
            }
            else if (encryptionType == 3)
            {
                aesKey = AESThenHMAC.NewKey();
                authKey = AESThenHMAC.NewKey();
                
                string secrete  = text.ToString();

                secrete = AESThenHMAC.SimpleEncrypt(secrete, aesKey, authKey);
                text.Clear();
                text.Append(secrete);


            }
            else
            {
                //throw
            }
        }

        /******************************************
         * Decrypt - Decrypt algorithm by reversing
         *  specific encryption algorithm indicated
         *  by user entered encryptionType
         *  
         * Decryption Technique:
         *  1) Vigenere XOR decryption:
         *   -> FINISH LATER
         *****************************************/

        public override void decrypt(int encryptionType)
        {
            int xor = 0;

            if (encryptionType == 1)
            {
                for (int i = 0; i < text.Length; i++)
                {
                    xor = text[i] ^ key[i%key.Length];
                    text[i] = (char) (xor - key[i%key.Length]);
                }
            }
            else if (encryptionType == 2)
            {
                //abeer
            }
            else if (encryptionType == 3)
            {
                Console.WriteLine("DECRYPT");

                string decrypted = AESThenHMAC.SimpleDecrypt(text.ToString(), aesKey, authKey);
                text.Clear();
                text.Append(decrypted);
            }
            else
            {
                //throw
            }
        }

        /******************************************
         * Export - Export file by using private 
         *  inherited variables filename, extension
         *  to create a new filename for encrypted
         *  or decrypted file
         *  
         * We may even add an option to overwrite
         *****************************************/

        public override void export()
        {

        }

        /******************************************
         * setKey - key must be set before encryption 
         *  and decryption begins!
         *  
         *  Jarid will handle passing this variable 
         *   through the GUI
         *****************************************/

        public override void setKey(string _key)
        {
            //check stuff
            key = _key;
        }


        /******************************************
         * TEST METHODS
         *****************************************/

        /******************************************
         * Print - Used to print variable text to 
         *  the console to help testing algorithms
         *****************************************/

        public override void print()
        {
            Console.WriteLine(text);
        }

    }

    /******************************************
     * End of CSDocument class
     *****************************************/

    /******************************************
     * Public Derived Class CSImage
     * 
     * Inherits all methods and variables from CSFile
     * 
     * private:
     *  height
     *  width
     *  image
     *****************************************/

    internal class CSImage : CSFile
    {
        /******************************************
         * Private Variables specific to this class
         ******************************************/
        private int height;
        private int width;
        private Bitmap image;

        public CSImage()
        {
            height = width = 0;
            image = null;
            filename = extension = key = null;
        }

        public override void import(string _filename)
        {
            //Image myImg = Image.FromFile("path here");
            string[] file_ext = _filename.Split('.');
            filename = file_ext[0];
            extension = file_ext[1];
            Console.WriteLine("We're here");
            image = (Bitmap) Bitmap.FromFile(_filename);
            height = image.Height;
            width = image.Width;
        }

        public override void encrypt(int encryptionType)
        {
            Color color = Color.FromName("Black");
            for (int i = 0; i < width; i++)
            {
                for (int j = 0; j < height; j++)
                {
                    image.SetPixel(i, j, color);
                }
            }
        }

        public override void decrypt(int encryptionType)
        {

        }

        public override void export()
        {
            // MIGHT HAVE TO SAVE AS A NEW FILE
            //newImage.EnhanceImage();
            //var tmpname = tempFileNamePath + ".bak";
            //System.IO.File.Delete(tmpname);
            //System.IO.File.Move(tempFileNamePath, tmpname);
            //newImage.Save(tempFileNamePath, System.Drawing.Imaging.ImageFormat.Jpeg);
            image.Save("C:/img.jpg");
        }

        public override void setKey(string _key)
        {

        }
    }

    /*****************************************
     *****************************************
     * MAIN PROGRAM
     *****************************************
     *****************************************/

    internal class Program
    {
        private static void Main(string[] args)
        {
            /*****************************************
             * -Change this area to fit your need.
             * -Change filename to fit your needs
             * -Change encryption type to:
             *  2 for abeer, 3 for kyle
             *****************************************/

            int encryptionType = 3;
            string filename = "test.txt"; // <- insert here, jarid!

            /****************************************
             * DO NOT TOUCH
             ****************************************/

            if (!(File.Exists(filename)))
                Console.WriteLine("\nFile Not Found!");
            
            //file is found
            else
            {
                string[] file_ext = filename.Split('.');
                file_ext[1] = file_ext[1].ToLower();

                CSFile test;
                if (file_ext[1] == "doc" || file_ext[1] == "docx" || file_ext[1] == "txt" || file_ext[1] == "xls" ||
                    file_ext[1] == "xlsx")
                {
                    // Documents
                    test = new CSDocument();

                    test.import(filename);
                    test.setKey("abc123");

                    Console.WriteLine("\nOriginal Text\n");
                    test.print();

                    Console.WriteLine("\nEncrypted Text\n");
                    test.encrypt(encryptionType);
                    test.print();

                    Console.WriteLine("\nDecrypted Text\n");
                    test.decrypt(encryptionType);
                    test.print();
                }
                else if (file_ext[1] == "png" || file_ext[1] == "bmp" || file_ext[1] == "jpg" || file_ext[1] == "jpeg")
                {
                    // Images
                    test = new CSImage();

                    test.import(filename);
                    test.setKey("abc123");

                    Console.WriteLine("\nEncrypting\n");
                    test.encrypt(encryptionType);
                    test.export();

                    Console.WriteLine("\nDecrypteding\n");
                    test.decrypt(encryptionType);
                    test.print();
                }
                else if (file_ext[1] == "mp4")
                {
                    // Videos
                }
                else
                {
                    Console.WriteLine("\nUnrecognized File Type");
                }

                // return 0 for jarid??
            }
        }
    }
}
