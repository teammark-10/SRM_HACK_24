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
import { data } from "autoprefixer";

const Toprightcard = () => {
  const [listening, setListening] = useState(false);
  // const [previousString, setPreviousString] = useState("");
  // const [nextTwoWords, setNextTwoWords] = useState("");
  const [isOpen, setIsOpen] = useState(false);
  // const [transcriptQueue, setTranscriptQueue] = useState([]);
  // const [previousTranscript, setPreviousTranscript] = useState("");
  const [liveCaption, setLiveCaption] = useState("");

  const closeModal = () => {
    setIsOpen(false);
  };

  const handleFileUpload = (e) => {
    const file = e.target.files[0];
    // Handle file upload logic here
    console.log("Uploaded file:", file);
  };

  const [students, setStudents] = useState([
    "",
    "",
    "------",
    "------",
    "-------",
    "-------",
  ]);

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
      
      const words = transcript.split(" ");
      // Update live caption
      if (words.length >= 1) {
        const updatedCaption = words.slice(-1).join(" ");
        setLiveCaption(updatedCaption);
      } else {
        const updatedCaption = (liveCaption + " " + transcript).trim();
        setLiveCaption(updatedCaption);
      }
      // setPreviousTranscript(words);

      //   // Split the previous string into an array of words
      //   const previousWords = previousString.split(" ");

      //   // Find the next two words added from the previous string
      //   const newlyAddedWords = updatedWords.filter(
      //     (word) => !previousWords.includes(word)
      //   );
      //   setTranscriptQueue(prevQueue => {
      //     const newQueue = [...prevQueue, ...words];

      //     // Keep only the last 8 words
      //     if (newQueue.length > 8) {
      //         newQueue.splice(0, newQueue.length - 8);
      //     }

      //     return newQueue;
      // });

      //   // Take the next two words
      //   const nextTwoWords1 = newlyAddedWords.slice(0, 8).join(" ");

      //   // Update the state with the next two words
      //   setNextTwoWords(nextTwoWords1);

      // Update the previous string state
      // setPreviousString(transcriptQueue.join(" "));
      // Update Firebase Realtime Database with the latest transcript
      const db = getDatabase();
      set(ref(db, "teacher"), liveCaption);
      set(ref(db, "student"), transcript);
    }
  }, [transcript]);

  const handleStartListening = () => {
    setListening(true);
    setLiveCaption("");
    resetTranscript();
    SpeechRecognition.startListening();
  };

  const CORS_PROXY = "https://cors-anywhere.herokuapp.com/";
  const API_URL = "https://absentlist.onrender.com/summary";

  const handleStopListening = async () => {
    setListening(false);
    // Add a new document to the "Meeting summary" collection with auto-generated ID

    SpeechRecognition.stopListening();
  };
  const handleSubmit = async () => {
    try {
      const physicsDocRef = doc(db, "Notes", "English");
      // Data to be updated

      const dataToUpdate = {
        transcribe: transcript,
      };
      await updateDoc(physicsDocRef, dataToUpdate);
      console.log("Document added successfully with ID: ");
      Swal.showLoading(Swal.getDenyButton())
      const response = await axios.post(`${CORS_PROXY}${API_URL}`, {
        subject: "English",
      });
      const data = response.data;
      setStudents(data["data"]);
      console.log(students);
      console.log("Server Response:", data["data"]);
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
            className={` border border-[#dcdbe3e7] hover:bg-[#dcdbe3e7]  ${
              listening ? "" : " hidden"
            }  w-fit align-bottom text-black rounded-3xl`}
          >
            Submit
          </button>
        </div>
      </div>
      <div className="bg-[#f8d154] p-6 mt-2 flex flex-col  flex-1 h-1/3 text-white rounded-xl">
        <div className="flex justify-between">
          <div className=" border w-fit p-2 rounded-3xl text-sm">
            Last class Absentees
          </div>
          <div className=" border w-fit p-2 rounded-3xl text-sm">
            {students[1]}
          </div>
        </div>
        <div className="h-full flex p-3 text-xl">
          <div className=" divide-x  divide-gray-100 w-1/2">
            <ul role="list" className="divide-y  divide-gray-100">
              {students.slice(2).map((person, index) => (
                <li
                  key={index + 2}
                  className="flex justify-between gap-x-6 py-5"
                >
                  <div className="flex min-w-0 gap-x-4">
                    <div className="min-w-0 flex-auto">
                      <p className="text-sm font-semibold leading-6 text-gray-900">
                        {person}
                      </p>
                    </div>
                  </div>
                </li>
              ))}
            </ul>
          </div>
          <div className="text-black justify-center flex   items-center pl-10 ">
            <h1 className=" text-9xl">{students[0]}</h1>
            <p className="text-sm">Attendence </p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Toprightcard;
