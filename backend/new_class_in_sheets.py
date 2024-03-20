import io
import PyPDF2
from google.oauth2 import service_account
from googleapiclient.discovery import build
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.errors import HttpError
import os
import ast

from langchain.schema import HumanMessage
from langchain.chat_models import ChatOpenAI




openai_api_key =os.environ.get('OPENAI_API')
SCOPES = ["https://www.googleapis.com/auth/spreadsheets", "https://www.googleapis.com/auth/drive"]

def pdf_to_sheet(pdf_name):
    def search_worksheet(spreadsheet_id, worksheet_name):
        # Assuming credentials are automatically available in the environment
        found = False
        creds = None
        if os.path.exists("token.json"):
            creds = Credentials.from_authorized_user_file("token.json", SCOPES)
        if not creds or not creds.valid:
            if creds and creds.expired and creds.refresh_token:
                creds.refresh(Request())
            else:
                flow = InstalledAppFlow.from_client_secrets_file("./credentials.json", SCOPES)
                creds = flow.run_local_server(port=0)
            with open("token.json", "w") as token:
                token.write(creds.to_json())

        # Build the Sheets API service
        service = build('sheets', 'v4', credentials=creds)

        # Get worksheets from the spreadsheet
        response = service.spreadsheets().get(spreadsheetId=spreadsheet_id).execute()
        sheets = response.get('sheets', [])

        # Search for the specified worksheet
        for sheet in sheets:
            # found='sheet not found'
            # print("ulli")
            if sheet['properties']['title'] == worksheet_name:
                # print(f'Worksheet "{worksheet_name}" found in the spreadsheet.')
                return True

        # print(f'Worksheet "{worksheet_name}" not found in the spreadsheet.')
        return False

    def delete_worksheet_by_name(spreadsheet_id, worksheet_title):
        # Assuming credentials are automatically available in the environment
        creds = None
        if os.path.exists("token.json"):
            creds = Credentials.from_authorized_user_file("token.json", SCOPES)
        if not creds or not creds.valid:
            if creds and creds.expired and creds.refresh_token:
                creds.refresh(Request())
            else:
                flow = InstalledAppFlow.from_client_secrets_file("credentials.json", SCOPES)
                creds = flow.run_local_server(port=0)
            with open("token.json", "w") as token:
                token.write(creds.to_json())

        # Build the Sheets API service
        service = build('sheets', 'v4', credentials=creds)

        # List all sheets in the spreadsheet
        sheet_metadata = service.spreadsheets().get(spreadsheetId=spreadsheet_id).execute()
        sheets = sheet_metadata.get('sheets', [])

        # Check if the specified worksheet exists
        for sheet in sheets:
            title = sheet['properties']['title']
            if title == worksheet_title:
                # Delete the worksheet
                try:
                    service.spreadsheets().batchUpdate(
                        spreadsheetId=spreadsheet_id,
                        body={
                            "requests": [
                                {
                                    "deleteSheet": {
                                        "sheetId": sheet['properties']['sheetId']
                                    }
                                }
                            ]
                        }
                    ).execute()
                    return 'sucess'
                except HttpError as err:
                    error_details = err.content.decode('utf-8')
                    return error_details
            
    def create_worksheet(spreadsheet_id, worksheet_title):
        # Assuming credentials are automatically available in the environment
        creds = None
        if os.path.exists("token.json"):
            creds = Credentials.from_authorized_user_file("token.json", SCOPES)
        if not creds or not creds.valid:
            if creds and creds.expired and creds.refresh_token:
                creds.refresh(Request())
            else:
                flow = InstalledAppFlow.from_client_secrets_file("credentials.json", SCOPES)
                creds = flow.run_local_server(port=0)
            with open("token.json", "w") as token:
                token.write(creds.to_json())

        # Build the Sheets API service
        service = build('sheets', 'v4', credentials=creds)

        # Add a new worksheet to the spreadsheet
        try:
            service.spreadsheets().batchUpdate(
                spreadsheetId=spreadsheet_id,
                body={
                    "requests": [
                        {
                            "addSheet": {
                                "properties": {
                                    "title": worksheet_title
                                }
                            }
                        }
                    ]
                }
            ).execute()
            return 'sucess'
        except HttpError as err:
            error_code = err.resp.status
            # print("Error code:", error_code)
            if error_code == 400:
                error_details = err.content.decode('utf-8')
                return("Oops!!Class with the same name already exists.")
            elif error_code == 403:
                return("Forbidden: The request is forbidden.")
            elif error_code == 404:
                return("Not Found: The requested resource was not found.")
            elif error_code == 409:
                return("Conflict: The request could not be completed due to a conflict with the current state of the resource.")
            elif error_code == 500:
                return("Internal Server Error: The server encountered an internal error.")
            else:
                return("Unknown error occurred.")
    def typepromptmaker(statement):
        instructions = f"""You are teachers assisatantand your duty is to make a list of students from the string given to you .
        The statement given to you is {statement}
        The string may have many other words .You must find out names of students from the string and make a list of students.
        expectd output is a list of students.in the roll number order.
        example:['john','doe','jane','doe']
        only return the list no other sentences or words.
        """
        question=f"Find the names of students from the given string and make a  roll number wise list of students."

        prompt = instructions + question
        return typeaskgpt(prompt)

    def typeaskgpt(prompt):
        chat_model = ChatOpenAI(temperature=0, model='gpt-4', openai_api_key=openai_api_key, max_tokens=800)
        output = chat_model([HumanMessage(content=prompt)])
        response = output.content
        print(response)
        return response

    def extract_text_from_pdf(pdf_path):
        text = ""
        with open(pdf_path, 'rb') as file:
            reader = PyPDF2.PdfReader(file)
            num_pages = len(reader.pages)
            for page_num in range(num_pages):
                page = reader.pages[page_num]
                text += page.extract_text()
        return text
    def add_column(column_name, row_values, class_name, SAMPLE_SPREADSHEET_ID):
        # Set the target column to A
        target_column = 'B'

        # Authenticate
        creds = None
        if os.path.exists("token.json"):
            creds = Credentials.from_authorized_user_file("token.json", SCOPES)
        if not creds or not creds.valid:
            if creds and creds.expired and creds.refresh_token:
                creds.refresh(Request())
            else:
                flow = InstalledAppFlow.from_client_secrets_file("credentials.json", SCOPES)
                creds = flow.run_local_server(port=0)
            with open("token.json", "w") as token:
                token.write(creds.to_json())

        # Create the Google Sheets service
        try:
            service = build("sheets", "v4", credentials=creds)

            # Get the number of rows in the spreadsheet
            sheet = service.spreadsheets().get(spreadsheetId=SAMPLE_SPREADSHEET_ID).execute()
            num_rows = sheet['sheets'][0]['properties']['gridProperties']['rowCount']

            # print("Length of row_values:", len(row_values))
            # print("Number of rows in the spreadsheet:", num_rows)

            # Check if the number of values provided matches the number of rows
            # if len(row_values) != num_rows:
            #     print("Error: Number of attributes does not match the number of rows.")
            #     return

            new_column_range = {
                "range": f"{class_name}!{target_column}1:{target_column}",
                "values": [[column_name]] + [[str(row_values[i])] for i in range(len(row_values))]
            }

            service.spreadsheets().values().update(
                spreadsheetId=SAMPLE_SPREADSHEET_ID,
                range=f"{class_name}!{target_column}1:{target_column}",
                body=new_column_range,
                valueInputOption="RAW"
            ).execute()
            return 'success'
        except HttpError as err:
            return 'failed'
        
    def add_roll_column(column_name,class_name,num_rows,SAMPLE_SPREADSHEET_ID):
        next_column = 'A'

        num_rows = int(num_rows)

        creds = None
        if os.path.exists("token.json"):
            creds = Credentials.from_authorized_user_file("token.json", SCOPES)
        if not creds or not creds.valid:
            if creds and creds.expired and creds.refresh_token:
                creds.refresh(Request())
            else:
                flow = InstalledAppFlow.from_client_secrets_file("credentials.json", SCOPES)
                creds = flow.run_local_server(port=0)
            with open("token.json", "w") as token:
                token.write(creds.to_json())

        try:
            service = build("sheets", "v4", credentials=creds)
            row_values = [[int(i)] for i in range(1, num_rows + 1)]
            new_column_range = {
                "range": f"{class_name}!{next_column}1:{next_column}",
                "values": [[column_name]] + row_values
            }
            service.spreadsheets().values().update(
                spreadsheetId=SAMPLE_SPREADSHEET_ID,
                range=f"{class_name}!{next_column}1:{next_column}",
                body=new_column_range,
                valueInputOption="RAW"
            ).execute()
            return 'success'
        except HttpError as err:
            return 'failed'


    def pdf_to_sheet(file_path, class_name, SAMPLE_SPREADSHEET_ID):
        extracted_text = extract_text_from_pdf(file_path)
        if extracted_text:
            response = typepromptmaker(extracted_text)
            try:
                extracted_list = response.split('[')[-1].strip()
                extracted_list = '[' + extracted_list
                dat = ast.literal_eval(extracted_list)
                name_status = add_column("NAME", dat, class_name, SAMPLE_SPREADSHEET_ID)
                if name_status == 'success':
                    roll_status = add_roll_column('ROLL_NUM', class_name, len(dat), SAMPLE_SPREADSHEET_ID)
                    if roll_status == 'success':
                        return 'success'
            except ValueError as e:
                print("Error:", e)
                return 'failed'
        else:
            print("Failed to extract text from the file.")
            return None

    def new_class(class_name,file_path,spreadsheet_id):
        rt_list = []
        print(spreadsheet_id)
        if (search_worksheet(spreadsheet_id,class_name)==False):
            print('ihih false')
            if (search_worksheet(spreadsheet_id,'Sheet1')==True):
                # print('worksheet found')
                creation_stat=create_worksheet(spreadsheet_id,class_name)
                rt_list.append(creation_stat)
                del_status=delete_worksheet_by_name(spreadsheet_id,'Sheet1')
                rt_list.append(del_status)
            else:
                creation_stat=create_worksheet(spreadsheet_id,class_name)
                rt_list.append(creation_stat)
                rt_list.append('sucess')
            if rt_list[0]=='sucess' and rt_list[1]=='sucess':
                sheet_status=pdf_to_sheet(file_path,class_name,spreadsheet_id)
                if sheet_status=='success':
                    return 'sucess'
                else:
                    return 'sheet creation failed'
            elif rt_list[0]=='sucess' and rt_list[1]!='sucess':
                return rt_list[1]
            elif rt_list[0]!='sucess' and rt_list[1]=='sucess':
                return rt_list[0]
        elif (search_worksheet(spreadsheet_id,class_name)==True):
            print('ihih true')
            return "Class with the same name already exists."
        else:
            return "Sheet not found"

            
    class_name = f'{pdf_name}'
    file_path = f"{pdf_name}"
    spreadsheet_id = "1DdvyfGsz0Lzc_5t_tAy8srgsBU8DGH6OBaTfOqUhJC0"
    return new_class(class_name,file_path,spreadsheet_id)