--★閃光する情熱 天魔・母禮
function c114100118.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c114100118.descost)
	e1:SetTarget(c114100118.destg)
	e1:SetOperation(c114100118.desop)
	c:RegisterEffect(e1)
end
--
function c114100118.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsSetCard(0x221)
end
function c114100118.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114100118.cfilter,tp,LOCATION_GRAVE,0,2,nil)
		and e:GetHandler():GetAttackAnnouncedCount()==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c114100118.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c114100118.filter(c,atk)
	return c:IsFaceup() and c:GetDefense()<=atk and c:IsDestructable()
end
function c114100118.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c114100118.filter,tp,0,LOCATION_MZONE,c,c:GetAttack())
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c114100118.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c114100118.filter,tp,0,LOCATION_MZONE,c,c:GetAttack())
	if g:GetCount()>0 then
		Duel.SelectOption(tp,aux.Stringid(114100118,0))
		Duel.SelectOption(1-tp,aux.Stringid(114100118,0))
		Duel.Destroy(g,REASON_EFFECT)
	end
end
