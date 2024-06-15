"use client";
import clsx from "clsx";
import Image from "next/image";
import Link from "next/link";
import { usePathname } from "next/navigation";

const side_link = [
  [
    { name: "Dashboard", href: "/samuel/dashboard" },
    { name: "Courses", href: "/samuel/courses" },
    { name: "Finances", href: "/samuel/finances" },
  ],
  [
    { name: "Profile", href: "/samuel" },
    { name: "Settings", href: "/samuel/settings" },
  ],
];

export default function SideNav() {
  const pathname = usePathname();
  return (
    <div className="flex py-10  md:overflow-y-auto  flex-col justify-between space-y-5 bg-[hsl(197,27%,67%)] h-[91%] sticky top-0 rounded-tr-3xl">
      <div className={clsx("flex flex-col")}>
        {side_link[0].map((link) => {
          return (
            <Link
              href={link.href}
              key={link.name}
              className={clsx("md:px-12 py-4", {
                "text-[#0A7AAA] bg-[#E5F4FA] ": pathname === link.href,
              })}
            >
              <div>{link.name}</div>
            </Link>
          );
        })}
      </div>
      <div className="flex flex-col pb-5 ">
        {side_link[1].map((link) => {
          return (
            <Link
              href={link.href}
              key={link.name}
              className={clsx("md:px-12 py-4", {
                "text-[#0A7AAA] bg-[#E5F4FA] ": pathname === link.href,
              })}
            >
              <div>{link.name}</div>
            </Link>
          );
        })}
      </div>
    </div>
  );
}
