--魔法少女の円環
function c114001073.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,114000893)
	e2:SetTarget(c114001073.target)
	e2:SetOperation(c114001073.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c114001073.mjfilter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==tp and not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_MZONE)
		and ( c:IsSetCard(0x223) or c:IsSetCard(0x224) 
		or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
		or c:IsCode(32751480) or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(17720747) or c:IsCode(98358303) or c:IsCode(91584698) )--0x224
end
function c114001073.mgfilter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==tp and c:IsSetCard(0xcabb) and not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_MZONE)
end
function c114001073.lvextract(g)
	local lv=0
	local tc=g:GetFirst()
	while tc do
		local tlv=tc:GetLevel()
		if tlv>lv then lv=tlv end
		tc=g:GetNext()
	end
	return lv
end

function c114001073.mgspfilter(c,e,tp,lv)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(lv+3)
		and ( c:IsLocation(LOCATION_HAND) or ( c:IsLocation(LOCATION_REMOVED) and c:IsFaceup() ) )
		and ( c:IsSetCard(0x223) or c:IsSetCard(0x224) 
		or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
		or c:IsCode(32751480) or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(17720747) or c:IsCode(98358303) or c:IsCode(91584698) ) --0x224
end

function c114001073.mjspfilter(c,e,tp,lv)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(lv) and c:IsSetCard(0xcabb)
		and ( c:IsLocation(LOCATION_HAND) or ( c:IsLocation(LOCATION_REMOVED) and c:IsFaceup() ) )
end

function c114001073.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local eg1=eg:Filter(c114001073.mgfilter,nil,tp)
	local eg2=eg:Filter(c114001073.mjfilter,nil,tp)
	local mglv=c114001073.lvextract(eg1)
	local mjlv=c114001073.lvextract(eg2)
	if chk==0 then
		local sel=0
		if Duel.IsExistingMatchingCard(c114001073.mgspfilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,nil,e,tp,mglv) and mglv>0 then sel=sel+1 end
		if Duel.IsExistingMatchingCard(c114001073.mjspfilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,nil,e,tp,mjlv) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	local sel=e:GetLabel()
		if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(114001073,0))
		sel=Duel.SelectOption(tp,aux.Stringid(114001073,1),aux.Stringid(114001073,2))+1
	end
	e:SetLabel(sel)
	e:SetLabelObject(eg)
	local mark=eg:GetFirst()
	while mark do
		mark:RegisterFlagEffect(114001073,RESET_EVENT+0x5fe0000,0,1)
		mark=eg:GetNext()
	end
	if se1==1 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(114001073,0))
	else
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(114001073,1))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_REMOVED)
end
function c114001073.markchk(c)
	return c:GetFlagEffect(114001073)~=0
end
function c114001073.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	local sel=e:GetLabel()
	local rg=e:GetLabelObject()
	if sel==1 then
		local rg1=rg:Filter(c114001073.mgfilter,nil,tp):Filter(c114001073.markchk,nil)
		local mglv=c114001073.lvextract(rg1)
		if mglv==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c114001073.mgspfilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil,e,tp,mglv)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,205,tp,tp,false,false,POS_FACEUP)
		end
	else
		local rg2=rg:Filter(c114001073.mjfilter,nil,tp):Filter(c114001073.markchk,nil)
		local mjlv=c114001073.lvextract(rg2)
		if mjlv==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c114001073.mjspfilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil,e,tp,mjlv)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,205,tp,tp,false,false,POS_FACEUP)
		end
	end
end