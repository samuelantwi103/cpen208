import Button from "@/components/Button";
import Input from "@/components/input";
import Link from "next/link";
import React from "react";

type Props = {};
export const metadata = {
  title: "Register | CPEN UG",
};

const SignUpPage = (props: Props) => {
  return (
    <div className="min-h-[100vh] lg:max-w-[40rem] sm:max-w-[30rem] mx-4 md:ml-40">
      {/* Welcome Back Text */}
      <div
        id="Hero"
        className="text-4xl md:text-5xl flex text-nowrap font-bold items-end justify-start space-y-3 mb-5 w-full mt-2 "
      >
        <div>Create new account</div>
        <div className="text-[#0A7AAA]">.</div>
      </div>

      {/* Dont have an account */}
      <div className="flex space-x-2 font-bold  w-full mt-2 mb-8 ">
        <div>Have an account?</div>
        <Link href="/login" className="text-[#0A7AAA]">
          Sign In
        </Link>
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

        <Button className="self-center w-[15rem] text-white font-semibold text-xl">
          Register
        </Button>
      </form>
    </div>
  );
};

export default SignUpPage;
