--口袋妖怪 哥达鸭
function c80000104.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--summon with 1 tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000104,0))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(c80000104.otcon)
	e2:SetOperation(c80000104.otop)
	e2:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e2)   
	--remove
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(80000104,1))
	e12:SetCategory(CATEGORY_REMOVE)
	e12:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetCountLimit(1)
	e12:SetRange(LOCATION_MZONE)
	e12:SetTarget(c80000104.target)
	e12:SetOperation(c80000104.operation)
	c:RegisterEffect(e12)  
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000104,2))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,80000104)
	e3:SetCondition(c80000104.spcon2)
	e3:SetOperation(c80000104.op)
	c:RegisterEffect(e3)  
end
c80000104.lvdncount=1
c80000104.lvdn={80000103} 
function c80000104.otfilter(c,tp)
	return c:IsCode(80000103) and (c:IsControler(tp) or c:IsFaceup())
end
function c80000104.op(e,tp,eg,ep,ev,re,r,rp)
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,true,POS_FACEUP)
end
function c80000104.otcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c80000104.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	return c:GetLevel()>6 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.GetTributeCount(c,mg)>0
end
function c80000104.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c80000104.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg, REASON_SUMMON+REASON_MATERIAL)
end
function c80000104.tgfilter(c)
	return c:IsAbleToRemove()
end
function c80000104.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c80000104.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80000104.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c80000104.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c80000104.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c80000104.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end