"use client";
import clsx from "clsx";
import React, { HTMLAttributes, ReactNode } from "react";
import Link from "next/link";

type Props = {
  children: ReactNode;
  className?: string; // Accepts string for class names
};

const Button = ({ children, className, ...props }: Props) => {
  // Combine default styles with passed className using clsx
  const combinedClasses = clsx(
    "bg-[#0A7AAA] px-4 py-5 rounded-full min-w-fit min-h-[35px] text-center",
    className
  );

  return (
    <Link href="samuel/dashboard"  className={combinedClasses} {...props}>
      {children}
    </Link>
  );
};

export default Button;
