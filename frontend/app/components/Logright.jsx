import React, { useState, useEffect } from "react";
import SpeechRecognition, {
  useSpeechRecognition,
} from "react-speech-recognition";
import { addDoc, collection, doc, updateDoc } from "firebase/firestore";
import { getDatabase, ref, set } from "firebase/database";
import db from "../firebase";
import Swal from "sweetalert2";
import Modal from "react-modal";
import axios from "axios";
import { FaUpload } from "react-icons/fa6";
import { useRouter } from "next/navigation";

const Logright = () => {
  const [listening, setListening] = useState(false);
  const [previousString, setPreviousString] = useState("");
  const [nextTwoWords, setNextTwoWords] = useState("");
  const [isOpen, setIsOpen] = useState(false);
 


  const closeModal = () => {
    setIsOpen(false);
  };
  const router = useRouter();
  const handleFileUpload = async(e) => {
  
    const file = e.target.files[0];
    // Handle file upload logic here
    console.log("Uploaded file:", file);
  
    try {
        // Create form data object
        const formData = new FormData();
        formData.append('file', file);

        // Send POST request using Axios
        const response = await axios.post(`${CORS_PROXY}${API_URL}`, formData, {
            headers: {
                'Content-Type': 'multipart/form-data',
            },
        });

        // Handle response
        console.log('Response:', response.data);
    } catch (error) {
        // Handle error
        console.error('Error uploading PDF:', error);
    }
    Swal.fire( "Successfully uploaded", "success");
    setIsOpen(false);
    router.push('/dashboard');
  };

  
  const {
    resetTranscript,
    browserSupportsSpeechRecognition,
    listening: isListening,
    transcript,
  } = useSpeechRecognition();

  useEffect(() => {
    if (!browserSupportsSpeechRecognition) {
      console.log("Browser does not support speech recognition.");
    }
  }, [browserSupportsSpeechRecognition]);

  useEffect(() => {
    if (transcript) {
      // Split the updated string into an array of words
      const updatedWords = transcript.split(" ");

      // Split the previous string into an array of words
      const previousWords = previousString.split(" ");

      // Find the next two words added from the previous string
      const newlyAddedWords = updatedWords.filter(
        (word) => !previousWords.includes(word)
      );

      // Take the next two words
      const nextTwoWords1 = newlyAddedWords.slice(0, 4).join(" ");

      // Update the state with the next two words
      setNextTwoWords(nextTwoWords1);

      // Update the previous string state
      setPreviousString(transcript);
      // Update Firebase Realtime Database with the latest transcript
      const db = getDatabase();
      set(ref(db, "teacher"), nextTwoWords);
    }
  }, [transcript]);

  const handleStartListening = () => {
    setListening(true);
    resetTranscript();
    SpeechRecognition.startListening();
  };

  const CORS_PROXY = "https://cors-anywhere.herokuapp.com/";
  const API_URL = "https://srm-hack.onrender.com/upload";

  const handleStopListening = async () => {
    setListening(false);
    // Add a new document to the "Meeting summary" collection with auto-generated ID

    SpeechRecognition.stopListening();
  };
  const handleSubmit = async () => {
    setIsOpen(true);
  };

  return (
    <div className=" mt-5 mb-5 mr-5 flex flex-col flex-1 rounded-xl">
      <div className="bg-white drop-shadow-lg rounded-xl">
        <div className="px-20 py-72   items-center flex flex-col ">
          <h1 className="text-4xl flex justify-center font-semibold text-black">
            Upload Student List
          </h1>
        <button onClick={handleSubmit} className="text-purple-200 h-20 mt-10">
            {/* <Link href="/dashboard" className="flex gap-2 items-center">
                <FaUpload />
                Upload student list
            </Link> */}
            upload
        </button>
          <Modal
        isOpen={isOpen}
        onRequestClose={closeModal}
        style={{
          overlay: {
            backgroundColor: 'rgba(0, 0, 0, 0.5)',
          },
          content: {
            top: '50%',
            left: '50%',
            right: 'auto',
            bottom: 'auto',
            marginRight: '-50%',
            transform: 'translate(-50%, -50%)',
            border: 'none',
            background: 'white',
            padding: '20px',
            borderRadius: '8px',
            boxShadow: '0px 4px 10px rgba(0, 0, 0, 0.2)',
          },
        }}
      >
        <h2>Upload PDF</h2>
        <input type="file" onChange={handleFileUpload} accept=".pdf" />
        <button onClick={closeModal}>Close</button>
      </Modal>
        </div>
      </div>
    </div>
  );
};

export default Logright;
