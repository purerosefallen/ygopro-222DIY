--奥秘调界
function c23330016.initial_effect(c)
	--发动
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--攻击·守备上升
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTarget(c23330016.uptg)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(c23330016.upval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--无效化
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e3:SetTarget(c23330016.distarget)
	c:RegisterEffect(e3)
	--无效化效果
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(c23330016.disop)
	c:RegisterEffect(e4)
	--盖放
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_SZONE)
	e5:SetOperation(c23330016.setop)
	c:RegisterEffect(e5)
	
end
function c23330016.uptg(e,c)
	return c:IsType(TYPE_TUNER) and c:GetBaseAttack()==0
end
function c23330016.upval(e,c)
	return c:GetLevel()*400
end
function c23330016.distarget(e,c)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:GetSequence()>=0 and c:GetSequence()<=4
end
function c23330016.disop(e,tp,eg,ep,ev,re,r,rp)
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if tl==LOCATION_SZONE and seq>=0 and seq<=4 then
		Duel.NegateEffect(ev)
	end
end
function c23330016.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEDOWN)
	end
end