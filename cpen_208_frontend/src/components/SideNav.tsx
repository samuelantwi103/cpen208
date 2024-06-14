import Image from "next/image";
export default function SideNav() {
  return (
    <div className="flex p-6  md:overflow-y-auto md:p-12 flex-col justify-between space-y-5 bg-[hsl(197,27%,67%)] h-[89%]">
      <div className="flex flex-col gap-6">
        <div>Dashboard</div>
        <div>Courses</div>
        <div>Finances</div>
      </div>
      <div className="flex flex-col gap-6 pb-5">
        <div>Profile</div>
        <div>
          {/* <Image src="src" alt="alt" width={50} height={50} /> */}
          <div>Settings</div>
        </div>
      </div>
    </div>
  );
}
