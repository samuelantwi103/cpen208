"use client"
import Button from "@/components/Button";
import Input from "@/components/input";
import React, { useState } from "react";
// import { metadata } from '../layout';
import Link from 'next/link';

type Props = {};
// // 'use server'
// export const metadata = {
//   title: "Log In | CPEN UG",
// };

const LoginPage = (props: Props) => {
  const [email, setemail] = useState('');
  const [password, setpassword] = useState('');
  const [error, seterror] = useState('');


  return (
    <div className="min-h-[100vh] lg:max-w-[40rem] sm:max-w-[30rem] mx-4 md:ml-40">
      {/* Welcome Back Text */}
      <div
        id="Hero"
        className="text-3xl md:text-5xl flex text-nowrap font-bold items-end justify-start space-y-3 mb-5 w-full mt-2 "
      >
        <div>Welcome Back</div>
        <div className="text-[#0A7AAA]">.</div>
      </div>

      {/* Dont have an account */}
      <div className="flex space-x-2 font-bold  w-full mt-2 mb-8 ">
        <div>Don&apos;t have an account?</div>
        <Link href="/signup" className="text-[#0A7AAA]">Register</Link>
      </div>
      <form className="flex flex-col space-y-10" method="">
        {/* Email */}
        <Input label="Email" />
        {/* <Button>Login</Button> */}
        <Input label="Password" />
        {/* Forgot Password */}
        <div className="text-[#0A7AAA] self-end mt-10">Forgot Password?</div>
        {/* <div className="self-center h-auto w-auto"> */}
          <Button className="self-center w-[15rem] text-white font-semibold text-xl">Sign In</Button>
        {/* </div> */}
      </form>
    </div>
  );
};

export default LoginPage;

