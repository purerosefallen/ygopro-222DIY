--夏恋·物语
function c10123006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--cannot disable spsum
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c10123006.cdsstg)
	e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e2) 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c10123006.sumcon)
	e3:SetOperation(c10123006.sumsuc)
	c:RegisterEffect(e3)	
	--pos
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10123006,0))
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCondition(c10123006.sumcon)
	e4:SetTarget(c10123006.postg)
	e4:SetOperation(c10123006.posop)
	c:RegisterEffect(e4) 
end
function c10123006.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c10123006.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10123006.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10123006.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c10123006.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c10123006.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
function c10123006.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10123006.sumfilter,1,nil,tp)
end
function c10123006.chainlm(e,rp,tp)
	return tp==rp
end
function c10123006.sumfilter(c,tp)
	local mg=c:GetMaterial()
	return c:GetSummonType()==SUMMON_TYPE_SYNCHRO and mg:GetCount()>0 and mg:IsExists(c10123006.effilter,1,nil,tp) 
end
function c10123006.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c10123006.chainlm)
end
function c10123006.cdsstg(e,c)
	local mg=c:GetMaterial()
	return c:GetSummonType()==SUMMON_TYPE_SYNCHRO and mg:GetCount()>0 and mg:IsExists(c10123006.effilter,1,nil,e:GetHandlerPlayer())
end
function c10123006.effilter(c,tp)
	return c:IsSetCard(0x5334) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsReason(REASON_SYNCHRO)
end