"use client"
import 'babel-polyfill';
import { useRouter } from 'next/navigation';

import Leftcard from '../components/Leftcard'
import Rightcard from '../components/Toprightcard'





export default function Home() {
  const router = useRouter();
  const handledashboard = () => {
    router.push('/');
  };
  const handleNavigate = () => {
    router.push('/views');
  };

  return (
    <main className=" flex font-poppins font-semibold">
     <Leftcard/>
<Rightcard/>
    </main>
  )
}
