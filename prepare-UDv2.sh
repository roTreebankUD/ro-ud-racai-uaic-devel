#!/bin/bash
IN=ro-ud-racai-uaic-9522-ttl.conllu

# Check prerequisities
[ -f $IN ] || { echo "$IN is missing, ask Radu"; exit 1; }
udapy -h >/dev/null || { echo "udapy is not installed, see https://github.com/udapi/udapi-python"; exit 1; }

#rm -rf sections; mkdir sections; cd sections
#cat ../$IN | sed 's/^#/# newdoc id =/' | udapy read.Conllu split_docs=1 write.Conllu docname_as_file=1 print_text=0 print_sent_id=0

./split-UDv2.pl $IN
for a in train dev test; do
    echo -ne "$a tokens\t"
    grep '^[0-9]' ro-ud-$a.conllu | wc -l
done

SCENARIO="ud.ro.SetSpaceAfter ud.Convert1to2 ud.ro.FixNeg"
for a in train dev test; do
    mv ro-ud-$a.conllu v1-ro-ud-$a.conllu
    udapy -s $SCENARIO util.Eval bundle="bundle.bundle_id = '$a-'+bundle.bundle_id" < v1-ro-ud-$a.conllu > ro-ud-$a.conllu
done

for a in train dev test; do
    udapy -HAMC ud.MarkBugs < ro-ud-$a.conllu > bugs-$a.html
done