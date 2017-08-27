--神示的季风
function c10119008.initial_effect(c)
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
	e2:SetTarget(c10119008.cdsstg)
	e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e2) 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c10119008.sumcon)
	e3:SetOperation(c10119008.sumsuc)
	c:RegisterEffect(e3)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10119008,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCondition(c10119008.sumcon)
	e4:SetTarget(c10119008.destg)
	e4:SetOperation(c10119008.desop)
	c:RegisterEffect(e4)  
end

function c10119008.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10119008.sumfilter,1,nil,tp)
end

function c10119008.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c10119008.chainlm)
end

function c10119008.chainlm(e,rp,tp)
	return tp==rp
end

function c10119008.sumfilter(c,tp)
	local mg=c:GetMaterial()
	return c:GetSummonType()==SUMMON_TYPE_XYZ and mg:GetCount()>0 and mg:IsExists(c10119008.effilter,1,nil,tp) 
end

function c10119008.desfilter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end

function c10119008.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c10119008.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10119008.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c10119008.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function c10119008.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function c10119008.cdsstg(e,c)
	local mg=c:GetMaterial()
	return c:GetSummonType()==SUMMON_TYPE_XYZ and mg:GetCount()>0 and mg:IsExists(c10119008.effilter,1,nil,e:GetHandlerPlayer())
end

function c10119008.effilter(c,tp)
	return c:IsSetCard(0x6331) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsReason(REASON_XYZ)
end

