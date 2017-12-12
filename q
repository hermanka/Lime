select
tb_jadwal.kd_mk,
tb_mk.nm_mk,
tb_jadwal.jenis,
tb_swu.th_akdm,
tb_kary.nama as nama_dosen,
case tb_swu.ujian
     when 'A' then 'UAS'
     when 'T' then 'UTS'
end as ujian,

case tb_swu.ujian
     when 'A' then tb_jadwal.tgl_uas
     when 'T' then tb_jadwal.tgl_uts
end as tanggal,

case tb_swu.ujian
     when 'A' then tb_jadwal.kd_jam_uas
     when 'T' then tb_jadwal.kd_jam_uts
end as jam,


case tb_jadwal.jenis
     when 'T1' then 'TEORI'
     when 'T2' then 'TEORI'
     when 'P1' then 'PRAKTEK'
     when 'P2' then 'PRAKTEK'
end as tp,
case
    when kd_hari>5 then 'B'
    else 'A'
end as kelas,
case
    when kd_hari>5 then '90'
    else '100'
end as waktu,
case
    when substring(tb_jadwal.th_akdm,1,1)=1 then 'Ganjil'
    else 'Genap'
end as smt,
tb_soal.id_soal,
tb_soal.sifat

from
tb_mk,
tb_jadwal,
tb_swu,
tb_kary,
tb_soal
where
tb_jadwal.th_akdm=tb_swu.th_akdm AND
tb_jadwal.kd_mk=tb_mk.kd_mk AND
tb_jadwal.nik=tb_kary.nik AND
tb_jadwal.id_jadwal=tb_soal.id_jadwal AND
tb_jadwal.th_akdm=tb_soal.th_akdm AND
tb_jadwal.kd_mk=tb_soal.kd_mk AND
tb_jadwal.jenis=tb_soal.jenis
group by tb_soal.id_soal
order by tb_jadwal.tgl_uas,jam

