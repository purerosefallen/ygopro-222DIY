--秋语 晚风
function c10105007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--inactivatable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetValue(c10105007.effectfilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetValue(c10105007.effectfilter)
	c:RegisterEffect(e3) 
	--cannot disable spsum
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c10105007.cdsstg)
	e4:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e4) 
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c10105007.sumcon)
	e5:SetOperation(c10105007.sumsuc)
	c:RegisterEffect(e5)
	--banish
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10105007,0))
	e6:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c10105007.sumcon)
	e6:SetTarget(c10105007.rmtg)
	e6:SetOperation(c10105007.rmop)
	c:RegisterEffect(e6) 
end
function c10105007.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c10105007.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c10105009.mafilter(c,tp)
	return c:IsSetCard(0xc330) and c:IsPreviousLocation(LOCATION_MZONE+LOCATION_HAND) and c:GetPreviousControler()==tp and bit.band(c:GetReason(),0x40008)~=0x40008
end
function c10105009.sumfilter(c,tp)
	return c:GetMaterialCount()>0 and c:GetMaterial():IsExists(c10105009.mafilter,1,nil,tp)
end
function c10105007.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10105007.sumfilter,1,nil,tp)
end
function c10105007.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c10105007.chainlm)
end
function c10105007.chainlm(e,rp,tp)
	return tp==rp
end
function c10105007.cdsstg(e,c)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xc330)
end
function c10105007.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	local tc=te:GetHandler()
	return p==tp and bit.band(loc,LOCATION_ONFIELD)~=0 and tc:IsSetCard(0xd0) and tc~=e:GetHandler()
end