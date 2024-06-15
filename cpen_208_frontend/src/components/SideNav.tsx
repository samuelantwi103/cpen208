"use client";
import clsx from "clsx";
import Image from "next/image";
import Link from "next/link";
import { usePathname } from "next/navigation";

const side_link = [
  { name: "Dashboard", href: "/samuel/dashboard" },
  { name: "Courses", href: "/samuel/courses" },
  { name: "Finances", href: "/samuel/finances" },
];

export default function SideNav() {
  const pathname = usePathname();
  return (
    <div className="flex py-10  md:overflow-y-auto  flex-col justify-between space-y-5 bg-[hsl(197,27%,67%)] h-[91%] sticky top-0 rounded-tr-3xl">
      <div className={clsx("flex flex-col")}>
        {side_link.map((link) => {
          return (
            <div key={link.name}className={clsx("md:px-12 py-4",{ "text-[#0A7AAA] bg-[#E5F4FA] ": pathname === link.href })}>
              <Link href={link.href}>{link.name}</Link>
            </div>
          );
        })}
      </div>
      <div className="flex flex-col pb-5 ">
        <div className="md:px-12 py-4">Profile</div>
        <div className="md:px-12 ">
          {/* <Image src="src" alt="alt" width={50} height={50} /> */}
          <div>Settings</div>
        </div>
      </div>
    </div>
  );
}
