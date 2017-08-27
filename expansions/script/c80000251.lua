--口袋妖怪 风铃铃
function c80000251.initial_effect(c)
	--special summon
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_SPSUMMON_PROC)
	e8:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e8:SetRange(LOCATION_HAND)
	e8:SetCondition(c80000251.cctv)
	c:RegisterEffect(e8) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c80000251.target)
	e1:SetOperation(c80000251.activate)
	c:RegisterEffect(e1)
end
function c80000251.filter(c)
	return c:IsFaceup() and not c:IsType(TYPE_TUNER)
end
function c80000251.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c80000251.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80000251.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c80000251.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c80000251.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
	end
end   
function c80000251.fai(c)
	return c:IsFaceup() and c:IsSetCard(0x2d0) and c:IsRace(RACE_PSYCHO)
end
function c80000251.cctv(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c80000251.fai,c:GetControler(),LOCATION_MZONE,0,1,nil)
end