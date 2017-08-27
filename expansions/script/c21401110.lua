--弓之从者 阿拉什
function c21401110.initial_effect(c)
	c:EnableCounterPermit(0xf0f)
	--addcounter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c21401110.addcon)
	e1:SetOperation(c21401110.addop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c21401110.descost)
	e2:SetTarget(c21401110.destg)
	e2:SetOperation(c21401110.desop)
	c:RegisterEffect(e2)
end
function c21401110.addcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c21401110.addop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0xf0f,1)
end
function c21401110.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xf0f,1,REASON_COST)  end
	local c1=e:GetHandler():GetCounter(0xf0f)
	e:GetHandler():RemoveCounter(tp,0xf0f,1,REASON_COST)
	local c2=e:GetHandler():GetCounter(0xf0f)
	if c1==c2+1 then
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+0xf0f,e,0,tp,0,0)
	end
end
function c21401110.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c21401110.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if g:GetCount()>0 then
	    Duel.Destroy(g,REASON_EFFECT)
	    if Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
	    e1:SetType(EFFECT_TYPE_FIELD)
	    e1:SetCode(EFFECT_CANNOT_BP)
	    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	    e1:SetReset(RESET_PHASE+PHASE_END,3)
	    e1:SetTargetRange(1,1)
	    Duel.RegisterEffect(e1,tp)
		end
	end
end