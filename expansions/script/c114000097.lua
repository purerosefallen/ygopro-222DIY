--★祈る魔法少女 佐倉杏子
function c114000097.initial_effect(c)
	--sent to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCondition(c114000097.descon)
	e1:SetTarget(c114000097.destg)
	e1:SetOperation(c114000097.desop)
	c:RegisterEffect(e1)
end
function c114000097.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttackTarget()
	if d==c then d=Duel.GetAttacker() end
	e:SetLabelObject(d)
	return d and d:IsFaceup() and d:GetAttack()>c:GetAttack()
end
function c114000097.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Group.FromCards(Duel.GetAttacker(),Duel.GetAttackTarget())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c114000097.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=e:GetLabelObject()
	if c:IsFaceup() and c:IsRelateToEffect(e) and d:IsRelateToBattle() and d:GetAttack()>c:GetAttack() then
		Duel.SendtoGrave(c,REASON_EFFECT)
		Duel.SendtoGrave(d,REASON_EFFECT)
	end
end