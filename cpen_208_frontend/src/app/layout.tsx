import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import NavBar from "@/components/NavBar";
import Footer from "@/components/Footer";
import clsx from "clsx";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "CPEN UG",
  description:
    "Course Management System for Department of Computer Engineering UG",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <div className={clsx("bg-back-img bg-center bg-no-repeat bg-cover bg-fixed bg-origin-border")}>
          {/* <div className="bg-fixed blur-md bg-transparent"></div> */}
          <div className=" backdrop-blur">
            <NavBar />

            {children}
            {/* <Footer /> */}
          </div>
        </div>
      </body>
    </html>
  );
}
