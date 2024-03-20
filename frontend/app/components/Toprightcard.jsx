import React, { useState, useEffect } from "react";
import SpeechRecognition, {
  useSpeechRecognition,
} from "react-speech-recognition";
import { addDoc, collection, doc, updateDoc } from 'firebase/firestore';
import { getDatabase, ref, set } from "firebase/database";
import db from "../firebase";
import Swal from 'sweetalert2';
import Modal from 'react-modal';
import axios from 'axios';


const Toprightcard = () => {
  const [listening, setListening] = useState(false);
  const [previousString, setPreviousString] = useState("");
  const [nextTwoWords, setNextTwoWords] = useState("");
  const [isOpen, setIsOpen] = useState(false);



  const closeModal = () => {
    setIsOpen(false);
  };

  const handleFileUpload = (e) => {
    const file = e.target.files[0];
    // Handle file upload logic here
    console.log('Uploaded file:', file);
  };


  const people = [
    {
      name: "Leslie Alexander",
      email: "leslie.alexander@example.com",
      role: "Co-Founder / CEO",
      imageUrl:
        "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80",
      lastSeen: "3h ago",
      lastSeenDateTime: "2023-01-23T13:23Z",
    },
    {
      name: "Michael Foster",
      email: "michael.foster@example.com",
      role: "Co-Founder / CTO",
      imageUrl:
        "https://images.unsplash.com/photo-1519244703995-f4e0f30006d5?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80",
      lastSeen: "3h ago",
      lastSeenDateTime: "2023-01-23T13:23Z",
    },
    {
      name: "Dries Vincent",
      email: "dries.vincent@example.com",
      role: "Business Relations",
      imageUrl:
        "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80",
      lastSeen: null,
    },
    // {
    //   name: 'Lindsay Walton',
    //   email: 'lindsay.walton@example.com',
    //   role: 'Front-end Developer',
    //   imageUrl:
    //     'https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80',
    //   lastSeen: '3h ago',
    //   lastSeenDateTime: '2023-01-23T13:23Z',
    // },
  ];

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
  const API_URL = "https://studiesy-glass.onrender.com/summary";

  const handleStopListening = async () => {
    setListening(false);
    // Add a new document to the "Meeting summary" collection with auto-generated ID

    SpeechRecognition.stopListening();
  };
  const handleSubmit = async () => {
    setIsOpen(true);
    try {
      const physicsDocRef = doc(db, "Notes", "English");
      // Data to be updated

      const dataToUpdate = {
        transcribe: transcript,
      };
      await updateDoc(physicsDocRef, dataToUpdate);
      console.log("Document added successfully with ID: ");
      const response = await axios.post(`${CORS_PROXY}${API_URL}`, {
        subject: "English",
      });

      console.log("Server Response:", response.data);
    } catch (error) {
      console.error("Error adding document: ", error);
    }
    Swal.fire("Good job!", "Successfully summarized!", "success");
  };

  return (
    <div className=" mt-5 mb-5 mr-5 flex flex-col flex-1 rounded-xl">
      <div className="bg-[#8070eb] p-6 flex flex-col  flex-1 h-2/3 text-white rounded-xl">
        <div className=" border w-fit p-2 rounded-3xl text-sm">Live Class</div>
        <div className="h-full p-3 text-xl"> {transcript}</div>
        <div className="flex gap-2">
        <button
          onClick={isListening ? handleStopListening : handleStartListening}
          className=" bg-[#dcdbe3e7]  w-fit align-bottom text-black rounded-3xl"
        >
          {isListening ? "Stop class" : "Start class"}
        </button>
        <button
          onClick={handleSubmit}
          className={` border border-[#dcdbe3e7] hover:bg-[#dcdbe3e7]  ${listening?'':' hidden'}  w-fit align-bottom text-black rounded-3xl`}
        >
          Submit
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
      <div className="bg-[#f8d154] p-6 mt-2 flex flex-col  flex-1 h-1/3 text-white rounded-xl">
        <div className=" border w-fit p-2 rounded-3xl text-sm">
          Last class Absentees
        </div>
        <div className="h-full flex p-3 text-xl">
          <div className=" divide-x  divide-gray-100 w-1/2">
            {/* <ul role="list" className="divide-y  divide-gray-100">
              {people.map((person) => (
                <li
                  key={person.email}
                  className="flex justify-between gap-x-6 py-5"
                >
                  <div className="flex min-w-0 gap-x-4">
                   
                    <div className="min-w-0 flex-auto">
                      <p className="text-sm font-semibold leading-6 text-gray-900">
                        {person.name}
                      </p>
                      <p className="mt-1 truncate text-xs leading-5 text-gray-500">
                        {person.email}
                      </p>
                    </div>
                  </div>
                 
                </li>
              ))}
            </ul> */}
          </div>
          {/* <div className="text-black justify-center flex   items-center pl-10 ">
            <h1 className=" text-9xl">95%</h1>
            <p className="text-sm">Attendence </p>
          </div> */}
        </div>
      </div>
    </div>
  );
};

export default Toprightcard;
