--Darkest　纷乱的墓地
function c22231201.initial_effect(c)
	c:SetUniqueOnField(1,0,22231201)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCondition(c22231201.condition)
	e3:SetOperation(c22231201.operation)
	c:RegisterEffect(e3)
	--pos
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1,22231201)
	e6:SetCondition(c22231201.spcon)
	e6:SetCost(c22231201.spcost)
	e6:SetTarget(c22231201.sptg)
	e6:SetOperation(c22231201.spop)
	c:RegisterEffect(e6)
end
c22231201.named_with_Darkest_D=1
function c22231201.IsDarkest(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Darkest_D
end
function c22231201.cfilter(c)
	local np=c:GetPosition()
	local pp=c:GetPreviousPosition()
	return np~=pp
end
function c22231201.confilter(c)
	return c:IsFaceup() and c22231201.IsDarkest(c)
end
function c22231201.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22231201.cfilter,1,nil) and Duel.IsExistingMatchingCard(c22231201.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22231201.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFieldCard(1-tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(1-tp,LOCATION_GRAVE,0)-1)
	if tc then
		if Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)>0 then
			Duel.RegisterFlagEffect(tp,22231201,0,0,0)
			local flag=Duel.GetFlagEffect(tp,22231201)
			if flag%5==0 then Duel.Destroy(e:GetHandler(),REASON_EFFECT) end
		end
	end
end
function c22231201.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c22231201.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c22231201.filter(c,e,tp)
	return c22231201.IsDarkest(c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22231201.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	if chk==0 then return Duel.GetMZoneCount(tp)>1 and Duel.IsExistingTarget(c22231201.filter,tp,LOCATION_GRAVE,0,2,nil,e,tp) and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c22231201.filter,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c22231201.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetMZoneCount(tp)
	if ft<=1 then return false end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
	local tc1=sg:GetFirst()
	local tc2=sg:GetNext()
	Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc1:RegisterEffect(e1)
	local e2=e1:Clone()
	tc2:RegisterEffect(e2)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DISABLE_EFFECT)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	tc1:RegisterEffect(e3)
	local e4=e3:Clone()
	tc2:RegisterEffect(e4)
	Duel.SpecialSummonComplete()
end




