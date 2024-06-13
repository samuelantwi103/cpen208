import Button from "@/components/Button";
import Input from "@/components/input";
import React from "react";

type Props = {};
export const metadata = {
  title: "Register | CPEN UG",
};

const SignUpPage = (props: Props) => {
  return (
    <div className="min-h-[100vh] lg:max-w-[40rem] sm:max-w-[30rem] ml-40">
      {/* Welcome Back Text */}
      <div
        id="Hero"
        className="text-5xl flex font-bold items-baseline space-y-3 mb-5 w-full mt-2 "
      >
        <div>Create new account</div>
        <div className="text-[#0A7AAA]">.</div>
      </div>

      {/* Dont have an account */}
      <div className="flex space-x-2 font-bold  w-full mt-2 mb-8 ">
        <div>Have an account?</div>
        <div className="text-[#0A7AAA]">Sign In</div>
      </div>
      <form className="flex flex-col space-y-10 pb-[50px]" method="">
        {/* Email */}
        <Input label="Surname" />
        {/* <Button>Login</Button> */}
        <Input label="Other names" />
        {/* <Button>Login</Button> */}
        <Input label="Email" />
        {/* <Button>Login</Button> */}
        <Input label="Date of Birth" />
        {/* <Button>Login</Button> */}
        <Input label="Password" />

        <Button className="self-center min-w-[20em] text-white font-semibold text-xl">Register</Button>
      </form>
    </div>
  );
};

export default SignUpPage;
