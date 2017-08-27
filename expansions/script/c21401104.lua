--Lancer 库·丘林
function c21401104.initial_effect(c)
	c:EnableCounterPermit(0xf0f)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCost(c21401104.recost)
	e1:SetCondition(c21401104.reccon)
	e1:SetTarget(c21401104.rectg)
	e1:SetOperation(c21401104.recop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(c21401104.reptg)
	e2:SetOperation(c21401104.repop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE	)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetCountLimit(1)
	e3:SetCost(c21401104.rmcost)
	e3:SetTarget(c21401104.rmtg)
	e3:SetCondition(c21401104.rmcon)
	e3:SetOperation(c21401104.rmop)
	c:RegisterEffect(e3)
end
function c21401104.reccon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c21401104.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
    Duel.SendtoExtraP(e:GetHandler(),tp,REASON_COST)
end
function c21401104.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,e:GetHandler(),1,0,0)
end
function c21401104.recop(e,tp,eg,ep,ev,re,r,rp)
      Duel.Recover(tp,ev,REASON_EFFECT)
	  Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
end
function c21401104.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttack()>0 and e:GetHandler():GetDefense()>0 end
	return Duel.SelectYesNo(tp,aux.Stringid(21401104,0))
end
function c21401104.repop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_DEFENSE)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
end
function c21401104.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xf0f,3,REASON_COST) end
	local c1=e:GetHandler():GetCounter(0xf0f)
	e:GetHandler():RemoveCounter(tp,0xf0f,3,REASON_COST)
	local c2=e:GetHandler():GetCounter(0xf0f)
	if c1==c2+3 then
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+0xf0f,e,0,tp,0,0)
	end
end
function c21401104.rmcon(e)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and c:GetBattleTarget()
end
function c21401104.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetBattleTarget()
	if chk==0 then return tc and tc:IsControler(1-tp) and tc:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
	Duel.SetChainLimit(c21401104.limit(tc))
end
function c21401104.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc:IsRelateToBattle() then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c21401104.limit(c)
	return	function (e,lp,tp)
				return e:GetHandler()~=c
			end
end