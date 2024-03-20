import React from "react";
import { GoArrowDownLeft } from "react-icons/go";
import Image from "next/image";
import { FaLink } from "react-icons/fa";
import logo from "../../assets/logo.png";

const logLeftcard = () => {
  

const handlesheet = async(event) => {
    event.preventDefault();
        // Your form submission logic
        
        // Redirect to another website
        window.open('https://docs.google.com/spreadsheets/d/1DdvyfGsz0Lzc_5t_tAy8srgsBU8DGH6OBaTfOqUhJC0/edit#gid=1188757844');
}

  return (
    <div className="bg-[url('/backimage.jpg')] bg-cover w-1/2 m-5 h-screen pl-24 pb-7 rounded-xl drop-shadow-md ">
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
      {/* <div className=" pt-20">
        <p className=" text-grey-500 font-normal">Welcome to Augmented Class</p> */}

        {/* <div className=" pt-4 ">
          <h1 className=" font-semibold text-5xl  ">Transforming</h1>
          <h1 className=" font-semibold text-5xl  ">Education with </h1>
          <h1 className=" font-semibold text-5xl  ">/Augmented Class</h1>
        </div>
      */}
      
      {/* </div> */}
    </div>
  );
};

export default logLeftcard;
