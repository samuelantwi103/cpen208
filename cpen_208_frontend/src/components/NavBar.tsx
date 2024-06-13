'use client'
import Link from "next/link";
import React, { createContext } from "react";
import clsx from "clsx";

type Props = {};

const isLoginRegister = createContext(true);

const NavBar = (props: Props) => {
  return (
    <nav className="flex w-full  text-white p-4 px-40 align">
      <ul className="flex justify-between w-full text-nowrap items-center">
        
        <li className="flex justify-between w-fit h-fit gap-3 items-center text-black">
          <Link href={"/"} className="font-semibold text-[#0A7AAA]">CPEN UG</Link>

          <Link href={""} className={clsx()}>
            <div>About</div>
          </Link>
          <Link href={""}>
            <div>Contact Us</div>
          </Link>
        </li>
        <li className="flex justify-center  w-fit  text-white gap-3">
          <Link href={"/login"}>
            <div className="px-4 py-1 border-[#0A7AAA] text-black border-2 rounded-full min-h-[35px]">
              Log In
            </div>
          </Link>
          <Link href={"/signup"}>
            <div className="bg-[#0A7AAA] px-4 py-1 rounded-full min-h-[35px]">
              Register
            </div>
          </Link>
        </li>
      </ul>
    </nav>
  );
};

export default NavBar;
