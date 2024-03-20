from flask import Flask, request
import new_class_in_sheets


app = Flask(__name__)

@app.route('/upload', methods=['POST'])
def upload_pdf():
    # Check if the POST request has a file attached
    if 'file' not in request.files:
        return 'No file part'

    file = request.files['file']

    # Check if the file is empty
    if file.filename == '':
        return 'No selected file'

    # Check if the file is a PDF
    if not file.filename.endswith('.pdf'):
        return 'Invalid file format. Please upload a PDF file.'

    # Save the uploaded file
    file.save(file.filename)
    # class_name=request.form['class']  #class name for calling
    response=new_class_in_sheets.pdf_to_sheet(file.filename)
    return response



@app.route('/summarry', methods=['POST'])
def summarry():
    subject=request.json['class']
    

if __name__ == '__main__':
    app.run(debug=True)