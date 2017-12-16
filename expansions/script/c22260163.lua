--人间最弱 球磨川禊
function c22260163.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(c22260163.mfilter),2)
	c:EnableReviveLimit()
	--xyzlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c22260163.mlimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e6)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22260163,0))
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,222601631)
	e1:SetTarget(c22260163.sptg)
	e1:SetOperation(c22260163.spop)
	c:RegisterEffect(e1)
	--Release
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(22260163,1))
	e7:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_ATKCHANGE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,222601632)
	e7:SetCost(c22260163.thcost)
	e7:SetOperation(c22260163.thop)
	c:RegisterEffect(e7)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22260163,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,222601633)
	e2:SetTarget(c22260163.sptg2)
	e2:SetOperation(c22260163.spop2)
	c:RegisterEffect(e2)
end
c22260163.named_with_KuMaKawa=1
function c22260163.IsKuMaKawa(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_KuMaKawa
end
function c22260163.mlimit(e,c)
	if not c then return false end
	return c:GetAttack()~=0
end
function c22260163.mfilter(c,lc)
	return c:GetBaseAttack()==0 and c:IsCanBeLinkMaterial(lc)
end
function c22260163.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone(tp)
	local ft=Duel.GetMZoneCount(tp,g,tp,LOCATION_REASON_TOFIELD,zone)
	if chk==0 then return ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,22269999,nil,0x4011,0,0,1,RACE_MACHINE,ATTRIBUTE_EARTH,zone)end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,0,0)
end 
function c22260163.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	local ft=Duel.GetMZoneCount(tp,g,tp,LOCATION_REASON_TOFIELD,zone)
	if ft<1 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	for i=1,ft do
		local token=Duel.CreateToken(tp,22269999)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP,zone)
	end
	Duel.SpecialSummonComplete()
end
function c22260163.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=e:GetHandler():GetLinkedGroup():Filter(Card.IsReleasable,nil)
	if chk==0 then return cg:GetCount()>0 end
	e:SetLabel(Duel.Release(cg,REASON_COST)*700+cg:FilterCount(c22260163.cfilter,nil)*70+cg:FilterCount(Card.IsCode,nil,22269999))
end
function c22260163.thfilter(c)
	return c:IsCode(22261001,22261101) and c:IsAbleToHand()
end
function c22260163.cfilter(c)
	return c22260163.IsKuMaKawa(c) and c:IsType(TYPE_MONSTER)
end
function c22260163.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	local atk=e:GetLabel()-(e:GetLabel()%700)
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
	if (e:GetLabel()%700)>(e:GetLabel()%70) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
	if e:GetLabel()%70>0 and Duel.IsExistingMatchingCard(c22260163.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22260163,2)) then
		local tg=Duel.SelectMatchingCard(tp,c22260163.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,e:GetLabel()%70,nil)
		if tg:GetCount()>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
function c22260163.spfilter(c,e,tp)
	return c22260163.IsKuMaKawa(c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(22260163)
end
function c22260163.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsExistingMatchingCard(c22260163.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,0,0)
end
function c22260163.spop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct<1 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	local g=Duel.SelectMatchingCard(tp,c22260163.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if ct>1 then 
		local sg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_GRAVE,0,nil,g:GetFirst():GetCode()):RandomSelect(tp,ct-1)
		g:Merge(sg)
	end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end