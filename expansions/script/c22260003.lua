--实力胜负 球磨川禊
function c22260003.initial_effect(c)
	--xyzlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c22260003.mlimit)
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
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(22260003,0))
	e7:SetCategory(CATEGORY_SUMMON+CATEGORY_TOKEN)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	e7:SetTarget(c22260003.sptg)
	e7:SetOperation(c22260003.spop)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e8)
	--Disable
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(22260003,2))
	e9:SetCategory(CATEGORY_DISABLE)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1)
	e9:SetCost(c22260003.discost)
	e9:SetTarget(c22260003.distg)
	e9:SetOperation(c22260003.disop)
	c:RegisterEffect(e9)
end
c22260003.named_with_KuMaKawa=1
function c22260003.IsKuMaKawa(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_KuMaKawa
end
function c22260003.sumlimit(e,c)
	return c:GetAttack()~=0
end
function c22260003.mlimit(e,c)
	if not c then return false end
	return c:GetAttack()~=0
end
function c22260003.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:GetAttack()==0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22260003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22260003.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c22260003.sptfilter(c)
	return c:IsFacedown() or c:GetBaseAttack()~=0
end
function c22260003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c22260003.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetMatchingGroupCount(c22260003.sptfilter,tp,LOCATION_MZONE,0,nil)==0 and Duel.IsPlayerCanSpecialSummonMonster(tp,22269999,nil,0x4011,0,0,1,RACE_MACHINE,ATTRIBUTE_EARTH) and Duel.SelectYesNo(tp,aux.Stringid(22260003,1)) then
				local token=Duel.CreateToken(tp,22269999)
				Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c22260003.cfilter(c)
	return c:IsCode(22269999) and c:IsReleasable()
end
function c22260003.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c22260003.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c22260003.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c22260003.disfilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c22260003.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_ONFIELD) and c22260003.disfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22260003.disfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c22260003.disfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c22260003.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsDisabled() and tc:IsControler(1-tp) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end