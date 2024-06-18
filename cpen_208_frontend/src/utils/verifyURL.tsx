'use client'
import { redirect, usePathname } from "next/navigation";

export default function VerifyURL(){
const pathname = usePathname();
if(pathname.split('/')[0] != "samuel"){
  console.log(pathname.split('/')[0])
  redirect("/login")
}
return redirect("/login")
}

