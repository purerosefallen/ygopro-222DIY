--quickplay rule: doom bots of doom
function Auxiliary.DoomBotsOfDoom()
	doom_level=0
	math.randomseed(os.time())
	for i=1,100 do
		math.random()
	end
	local ex=Effect.GlobalEffect()
	ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ex:SetCode(EVENT_ADJUST)
	ex:SetOperation(function(e)
		for tp=0,1 do
			if Duel.IsAI(tp) then
				Auxiliary.StartDoom(tp)
				e:Reset()
				return
			end
		end
		e:Reset()
	end)
	Duel.RegisterEffect(ex,0)
	local tf=Card.RegisterEffect
	Card.RegisterEffect=function(c,e,f)
		if e:IsHasType(0x7f0) then
			local con=e:GetCondition()
			if con then
				e:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
					if con(e,tp,eg,ep,ev,re,r,rp) then return true end
					if tp==player_ai and Auxiliary.GetRandomResult(0.8) then return true end
					return false
				end)
			end
			local cost=e:GetCost()
			if cost then
				e:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==0 then return cost(e,tp,eg,ep,ev,re,r,rp,0) end
					if tp==player_ai and Auxiliary.GetRandomResult(0.8) then return end
					return cost(e,tp,eg,ep,ev,re,r,rp,1)
				end)
			end
		end
		tf(c,e,f)
	end
end
function Auxiliary.GetRandomResult(mul)
	local rate=doom_level*0.1*mul
	return math.random()<rate
end
function Auxiliary.StartDoom(tp)
	player_ai=tp
	doom_level=Duel.AnnounceNumber(1-tp,0,1,2,3,4,5,6,7,8,9,10)
	if doom_level==0 then return end
	local clp=Duel.GetLP(tp)
	local elp=math.random(doom_level*1000)
	Duel.SetLP(player_ai,clp+elp)
	local ex=Effect.GlobalEffect()
	ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ex:SetCode(EVENT_PREDRAW)
	ex:SetCondition(function() return Duel.GetTurnPlayer()==player_ai end)
	ex:SetOperation(function()
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then
			local g=Duel.GetFieldGroup(player_ai,LOCATION_GRAVE+LOCATION_REMOVED,0)
			Duel.SendtoDeck(g,nil,0,REASON_RULE+REASON_RETURN)
			Duel.ShuffleDeck(player_ai)
		end
		local ct=1
		local mul=1
		while Auxiliary.GetRandomResult(mul) and Duel.GetFieldGroupCount(player_ai,LOCATION_DECK,0)>ct do
			ct=ct+1
			mul=mul*0.8
		end
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(ct)
		Duel.RegisterEffect(e1,player_ai)
		local sct=1
		local smul=1
		while Auxiliary.GetRandomResult(smul) do
			sct=sct+1
			smul=smul*0.8
		end
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(sct)
		Duel.RegisterEffect(e1,player_ai)
		if Auxiliary.GetRandomResult(1) then
			local e1=Effect.GlobalEffect()
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
			e1:SetTargetRange(LOCATION_HAND,0)
			e1:SetTarget(function(e,c)
				return true
			end)
			e1:SetCondition(function(e,c,minc)
				if c==nil then return true end
				return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
			end)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,player_ai)
		end
	end)
	Duel.RegisterEffect(ex,tp)
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		return Auxiliary.GetRandomResult(0.3)
	end)
	e2:SetOperation(aux.TRUE)
	e2:SetValue(function(e,c)
		return c:IsOnField() and c:IsControler(player_ai) and c:GetReasonPlayer()~=player_ai
	end)
	Duel.RegisterEffect(e2,player_ai)
	local ex=Effect.GlobalEffect()
	ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ex:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	ex:SetOperation(function()
		local ac=Duel.GetAttacker()
		if ac and ac:IsControler(player_ai) and ac:GetAttack()>0 then
			local atk=math.random(math.ceil(ac:GetAttack()*doom_level*0.1))
			local e1=Effect.CreateEffect(ac)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(0x1fe1000+RESET_PHASE+PHASE_DAMAGE_CAL)
			e1:SetValue(atk)
			ac:RegisterEffect(e1,true)
		end
	end)
	Duel.RegisterEffect(ex,player_ai)
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_HAND_LIMIT)
	e1:SetTargetRange(1,0)
	e1:SetValue(99)
	Duel.RegisterEffect(e1,player_ai)
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_EXTRA_TOMAIN_KOISHI)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,player_ai)
end