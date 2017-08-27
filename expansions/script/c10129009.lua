--地狱判官 拉达曼迪斯
function c10129009.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),2,false)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c10129009.splimit)
	c:RegisterEffect(e0)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10129009,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10129009)
	e1:SetCondition(c10129009.eqcon)
	e1:SetTarget(c10129009.eqtg)
	e1:SetOperation(c10129009.eqop)
	c:RegisterEffect(e1)  
	--special summon equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10129009,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1,10129109)
	e2:SetTarget(c10129009.sptg)
	e2:SetOperation(c10129009.spop)
	c:RegisterEffect(e2)
end
function c10129009.splimit(e,se,sp,st)
	return st==SUMMON_TYPE_FUSION+101
end
function c10129009.spfilter(c,e,tp,ec)
	return c:GetEquipTarget()==ec and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp)
end
function c10129009.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c10129009.spfilter(chkc,e,tp,c) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c10129009.spfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10129009.spfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e,tp,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10129009.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_DISABLE)
	   e1:SetReset(RESET_EVENT+0xfe0000)
	   tc:RegisterEffect(e1)
	   local e2=e1:Clone()
	   e2:SetCode(EFFECT_DISABLE_EFFECT)
	   tc:RegisterEffect(e2)
	   local e3=e1:Clone()
	   e3:SetCode(EFFECT_CHANGE_RACE)
	   e3:SetValue(RACE_ZOMBIE)
	   tc:RegisterEffect(e3)
	end
end
function c10129009.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c10129009.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToChangeControler() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsAbleToChangeControler,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,Card.IsAbleToChangeControler,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c10129009.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		if Duel.Equip(tp,tc,c,false)==0 then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(c10129009.eqlimit)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	else Duel.SendtoGrave(tc,REASON_EFFECT) end
end
function c10129009.eqlimit(e,c)
	return e:GetOwner()==c
end