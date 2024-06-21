"use client";
import useStore from "@/app/api/toggle";
// import toggle from "@/app/api/data";
import clsx from "clsx";
import {
  CreditCard,
  LayoutDashboard,
  LibraryBig,
  Settings,
  User,
} from "lucide-react";
import Image from "next/image";
import Link from "next/link";
import { usePathname } from "next/navigation";

const side_link = [
  [
    { name: "Dashboard", href: "/samuel/dashboard", icon: <LayoutDashboard /> },
    { name: "Courses", href: "/samuel/courses", icon: <LibraryBig /> },
    { name: "Finances", href: "/samuel/finances", icon: <CreditCard /> },
  ],
  [
    { name: "Profile", href: "/samuel", icon: <User /> },
    { name: "Settings", href: "/samuel/settings", icon: <Settings /> },
  ],
];

export default function SideNav() {
  const pathname = usePathname();
  const { isOpen } = useStore();
  return (
    <div className="h-full fixed">
      <div
        className={clsx(
          `md:flex pt-10 pb-5 md:overflow-y-auto flex-col justify-between space-y-5 bg-[hsl(197,27%,67%)] md:top-20 h-[calc(100vh-80px)] w-[300px] rounded-tr-3xl z-30 `,
          `${
            isOpen
              ? "transform translate-x-[0px]  left-0 md:flex md:sticky top-16 z-[400]"
              : "transform translate-x-[0px] sticky hidden md:flex md:sticky"
          }`
        )}
      >
        <div className={clsx("flex flex-col")}>
          {side_link[0].map((link) => {
            return (
              <Link
                href={link.href}
                key={link.name}
                className={clsx(
                  "md:px-12 py-4 flex gap-2",
                  {
                    "text-[#0A7AAA] bg-[#E5F4FA] ": pathname === link.href,
                  },
                  `${isOpen ? "px-10" : ""}`
                )}
              >
                <div>{link.icon}</div>
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
                className={clsx(
                  "md:px-12 py-4 flex gap-2",
                  {
                    "text-[#0A7AAA] bg-[#E5F4FA] ": pathname === link.href,
                  },
                  `${isOpen ? "px-10" : "sticky hidden"}`
                )}
              >
                <div>{link.icon}</div>
                <div>{link.name}</div>
              </Link>
            );
          })}
        </div>
      </div>
    </div>
  );
}
