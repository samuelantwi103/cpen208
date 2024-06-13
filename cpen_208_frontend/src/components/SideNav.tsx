import Image from "next/image";
export default function SideNav() {
  return (
    <div className="flex flex-col justify-between space-y-5 bg-[#93B4C1]">
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
