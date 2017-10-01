--剑之从者 阿尔托利亚·潘德拉贡
function c21401122.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xf01),1)
	c:EnableReviveLimit()
	c:EnableCounterPermit(0xf0f)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c21401122.imcon)
	e1:SetValue(c21401122.imfilter)
	c:RegisterEffect(e1)
    --boost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(300)
	c:RegisterEffect(e2)
    --disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(c21401122.distg)
	c:RegisterEffect(e3)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c21401122.descost)
	e5:SetTarget(c21401122.destg)
	e5:SetOperation(c21401122.desop)
	c:RegisterEffect(e5)
end
function c21401122.imcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c21401122.imfilter(e,te)
	return (te:IsActiveType(TYPE_SPELL) or (te:IsActiveType(TYPE_MONSTER) and te:GetHandler():GetRace(RACE_SPELLCASTER)))
	and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c21401122.distg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end
function c21401122.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xf0f,5,REASON_COST) end
	local c1=e:GetHandler():GetCounter(0xf0f)
	e:GetHandler():RemoveCounter(tp,0xf0f,5,REASON_COST)
	local c2=e:GetHandler():GetCounter(0xf0f)
	if c1==c2+5 then
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+0xf0f,e,0,tp,0,0)
	end
end
function c21401122.sfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c21401122.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local op=0
	local g1=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(c21401122.sfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(21401122,0))
	if g1:GetCount()>0 and g2:GetCount()>0 then
		op=Duel.SelectOption(tp,aux.Stringid(21401122,1),aux.Stringid(21401122,2))+1
	elseif g1:GetCount()>0 then
		op=Duel.SelectOption(tp,aux.Stringid(21401122,1))+1
	elseif g2:GetCount()>0 then
		op=Duel.SelectOption(tp,aux.Stringid(21401122,2))+2
	end
	if op==1 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
	elseif op==2 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,g2:GetCount(),0,0)
	end
	e:SetLabel(op)
end
function c21401122.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif e:GetLabel()==2 then
		local g=Duel.GetMatchingGroup(c21401122.sfilter,tp,0,LOCATION_ONFIELD,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
end