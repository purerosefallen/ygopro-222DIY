--狂暴大鸡鸡
function c10173028.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10173028,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,10173028)
	e1:SetTarget(c10173028.settg)
	e1:SetOperation(c10173028.setop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10173028,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,10173128)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(c10173028.spcon)
	e2:SetTarget(c10173028.sptg)
	e2:SetOperation(c10173028.spop)
	c:RegisterEffect(e2)
end
function c10173028.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,c) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not c:IsForbidden() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,tp,LOCATION_ONFIELD+LOCATION_HAND)
end
function c10173028.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,c)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not c:IsForbidden() and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
	   Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	   local e1=Effect.CreateEffect(c)
	   e1:SetCode(EFFECT_CHANGE_TYPE)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	   e1:SetReset(RESET_EVENT+0x1fc0000)
	   e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	   c:RegisterEffect(e1)
	end
end
function c10173028.cfilter(c,tp)
	return c:IsControler(tp) and c:IsReason(REASON_DESTROY)
end
function c10173028.cfilter2(c,tp)
	return c10173028.cfilter(c,tp) and c:IsReason(REASON_EFFECT)
end
function c10173028.spcon(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(0)
	if eg:IsExists(c10173028.cfilter2,2,nil,tp) then e:SetLabel(100) end
	return eg:IsExists(c10173028.cfilter,1,nil,tp)
end
function c10173028.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and e:GetLabel()~=0) or (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not c:IsForbidden()) end
end
function c10173028.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=0
	if not c:IsRelateToEffect(e) then return end
	local sp=(e:GetLabel()~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
	local set=(Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not c:IsForbidden())
	if sp and (not set or Duel.SelectYesNo(tp,aux.Stringid(10173028,2))) then
	   Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	elseif set then
	   Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	   local e1=Effect.CreateEffect(c)
	   e1:SetCode(EFFECT_CHANGE_TYPE)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	   e1:SetReset(RESET_EVENT+0x1fc0000)
	   e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	   c:RegisterEffect(e1)
	end
end