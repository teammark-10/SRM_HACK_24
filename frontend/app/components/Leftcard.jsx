import React from "react";
import { GoArrowDownLeft } from "react-icons/go";
import Image from "next/image";
import { FaLink } from "react-icons/fa";
import logo from "../../assets/logo.png";

const Leftcard = () => {
  

const handlesheet = async(event) => {
    event.preventDefault();
        // Your form submission logic
        
        // Redirect to another website
        window.open('https://docs.google.com/spreadsheets/d/1DdvyfGsz0Lzc_5t_tAy8srgsBU8DGH6OBaTfOqUhJC0/edit#gid=1188757844');
}

  return (
    <div className="bg-white w-1/2 m-5  pl-24 pb-7 rounded-xl drop-shadow-md ">
      <div className="pt-3 flex items-center text-2xl font-light">
        {" "}
        <Image
          className=" "
          src={logo}
          width={80}
          height={80}
          alt="Picture of the author"
        />Eduverse
      </div>
      <div className=" pt-36">
        <p className=" text-gray-400 font-normal">Welcome to Augmented Class</p>

        <div className=" pt-4 ">
          <h1 className=" font-semibold text-5xl  ">Transforming</h1>
          <h1 className=" font-semibold text-5xl  ">Education with </h1>
          <h1 className=" font-semibold text-5xl  ">/Augmented Class</h1>
        </div>
        <div className="gap-4 pt-6 flex">
          <button className=" text-white rounded-3xl mt-5">
            Start Learning
          </button>
          <button onClick={handlesheet} className="bg-[#dcdbe3] rounded-3xl mt-5 flex items-center gap-2">
            <FaLink />
            Attendence sheet
          </button>
        </div>
        <div className="pt-32">
          <GoArrowDownLeft size={30} />
          <p className="  text-gray-400 font-light text-2xl">
            Innovative <span className=" font-semibold">AugmentedClass</span>
          </p>
          <p className="  text-gray-400 font-light text-2xl">
            With <span>OnlinePlatform</span>
          </p>
        </div>
      </div>
    </div>
  );
};

export default Leftcard;
