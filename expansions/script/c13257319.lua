--超时空战斗机-Big Core Custom
function c13257319.initial_effect(c)
	c:EnableCounterPermit(0x1f)
	--special summon
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetCode(EVENT_DESTROYED)
	e11:SetRange(LOCATION_HAND)
	e11:SetOperation(c13257319.regop)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e12)
	--Destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c13257319.desreptg)
	e1:SetOperation(c13257319.desrepop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c13257319.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--Power Capsule
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13257319,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLED)
	e4:SetTarget(c13257319.pctg)
	e4:SetOperation(c13257319.pcop)
	c:RegisterEffect(e4)
	c13257319[c]=e4
	
end
function c13257319.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and (c:IsSetCard(0x351) or c:IsSetCard(0x15))
end
function c13257319.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:IsExists(c13257319.cfilter,1,nil,tp) and rp~=tp and bit.band(r,REASON_EFFECT)~=0  then
		--spsummon
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(13257319,4))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_HAND)
		e1:SetCondition(c13257319.spcon)
		e1:SetOperation(c13257319.spop)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c13257319.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMZoneCount(tp)>0
end
function c13257319.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(11,0,aux.Stringid(13257319,7))
end
function c13257319.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReason(REASON_EFFECT+REASON_BATTLE)
		and e:GetHandler():GetCounter(0x1f)>0 end
	return true
end
function c13257319.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x1f,1,REASON_EFFECT)
end
function c13257319.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1f,3)
end
function c13257319.eqfilter(c,ec)
	return c:IsSetCard(0x3352) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function c13257319.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipCount()>0 or  Duel.IsExistingMatchingCard(c13257319.eqfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	e:SetCategory(CATEGORY_EQUIP)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
end
function c13257319.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eq=c:GetEquipGroup()
	local g=eq:Filter(Card.IsAbleToDeck,nil)
	local op=0
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(13257321,3)) then op=1
	elseif Duel.GetLocationCount(tp,LOCATION_SZONE)==0 and g:GetCount()>0 then op=1
	end
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	g=Duel.SelectMatchingCard(tp,c13257319.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c)
	end
end
