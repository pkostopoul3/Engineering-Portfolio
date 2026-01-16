akmes = [
    [1, 2, 48], [1, 3, 52], [1, 4, 6],
    [2, 3, 57], [2, 5, 12],
    [3, 4, 52], [3, 5, 48], [3, 6, 52], [3, 7, 9],
    [4, 7, 26],
    [5, 6, 96], [5, 8, 76],
    [6, 7, 52], [6, 8, 38], [6, 9, 9],
    [7, 9, 38],
    [8, 9, 96], [8, 10, 26],
    [9, 10, 6]
]

synolo_komvon = 10
epilegmenoi_komvoi = {1}
telikes_akmes = []
synoliko_kostos = 0

while len(epilegmenoi_komvoi) < synolo_komvon:
    elaxisto_varos = 999999
    kalyteri_akmi = None

    for k1, k2, varos in akmes:
        if (k1 in epilegmenoi_komvoi) and (k2 not in epilegmenoi_komvoi):
            if varos < elaxisto_varos:
                elaxisto_varos = varos
                kalyteri_akmi = [k1, k2, varos]
        
        elif (k2 in epilegmenoi_komvoi) and (k1 not in epilegmenoi_komvoi):
            if varos < elaxisto_varos:
                elaxisto_varos = varos
                kalyteri_akmi = [k1, k2, varos]

    if kalyteri_akmi:
        k1, k2, varos = kalyteri_akmi
        telikes_akmes.append(kalyteri_akmi)
        synoliko_kostos = synoliko_kostos + varos
        
        epilegmenoi_komvoi.add(k1)
        epilegmenoi_komvoi.add(k2)
        
        print(f"Prosthiki akmis: {k1}-{k2} me kostos {varos}")

print(f"\nTo Synoliko Kostos einai: {synoliko_kostos}")