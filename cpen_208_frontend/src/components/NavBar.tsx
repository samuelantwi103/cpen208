'use client'
import Link from "next/link";
import React, { createContext } from "react";
import { Menu } from 'lucide-react';
import clsx from "clsx";

type Props = {};

const isLoginRegister = createContext(true);

const NavBar = (props: Props) => {
  return (
    <nav className="flex  text-white p-4 sm:px-6 md:pl-[20vw] xl:pl-[15vw] align">
      <ul className="flex justify-between w-full text-nowrap items-center">
        <li><Menu color="#000000" /></li>
        <li className="flex justify-between h-fit sm:gap-3 items-center text-black">
          <Link href={"/"} className="font-semibold text-[#0A7AAA]">CPEN UG</Link>

          <Link href={""} className={clsx("hidden sm:block")}>
            <div>About</div>
          </Link>
          <Link href={""} className="hidden sm:block">
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
