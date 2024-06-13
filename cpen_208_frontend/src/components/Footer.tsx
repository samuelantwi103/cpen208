import Link from 'next/link'
import React from 'react'


type Props = {}

const Footer = (props: Props) => {
  return (
    <footer className="flex w-full bg-cyan-950 text-white p-4 align">
      <ul className="flex justify-between w-full text-nowrap items-center">
        <li className="flex justify-center">
          <Link href={"/"}>CPEN UG</Link>
        </li>
        <li className="flex justify-center w-fit h-fit gap-3 items-center">
        © 2024
        </li>
        <li className="flex justify-center  w-fit bg-cyan-950 text-white gap-3">
          Privacy Policy
        </li>
      </ul>
    </footer>
  )
}

export default Footer