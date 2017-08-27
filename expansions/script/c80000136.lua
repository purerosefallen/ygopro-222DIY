--口袋妖怪妖精之霞谷
function c80000136.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot disable summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x2d0))
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	c:RegisterEffect(e3)
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c80000136.limcon)
	e4:SetOperation(c80000136.limop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCode(EVENT_CHAIN_END)
	e6:SetOperation(c80000136.limop2)
	c:RegisterEffect(e6)
	--indestructable
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e7:SetRange(LOCATION_SZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetValue(c80000136.indval)
	c:RegisterEffect(e7)
	--Activate
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_TOHAND)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetRange(LOCATION_FZONE)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetHintTiming(0,0x1e0)
	e8:SetCountLimit(1,80000136)
	e8:SetTarget(c80000136.target)
	e8:SetOperation(c80000136.activate)
	c:RegisterEffect(e8)
	--immune effect
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_IMMUNE_EFFECT)
	e9:SetRange(LOCATION_SZONE)
	e9:SetTargetRange(LOCATION_ONFIELD,0)
	e9:SetValue(c80000136.efilter)
	c:RegisterEffect(e9)
end
function c80000136.efilter(e,re)
	return re:GetHandler():IsRace(RACE_DRAGON)
end
function c80000136.indval(e,c)
	return c:IsRace(RACE_DRAGON)
end
function c80000136.limfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsSetCard(0x2d0)
end
function c80000136.limcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c80000136.limfilter,1,nil,tp)
end
function c80000136.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(c80000136.chainlm)
	else
		e:GetHandler():RegisterFlagEffect(80000136,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c80000136.limop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetOverlayCount()>0 and e:GetHandler():GetFlagEffect(80000136)~=0 then
		Duel.SetChainLimitTillChainEnd(c80000136.chainlm)
	end
	e:GetHandler():ResetFlagEffect(80000136)
end
function c80000136.chainlm(e,rp,tp)
	return tp==rp
end
function c80000136.filter(c,e,tp)
	return c:IsSetCard(0x2d0) and c:IsAbleToHand() and c:IsFaceup()
end
function c80000136.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(c80000136.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c80000136.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c80000136.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end