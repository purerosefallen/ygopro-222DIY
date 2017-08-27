--太虚真龙·太古真神龙
function c10163009.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c10163009.spcon)
	e2:SetOperation(c10163009.spop)
	c:RegisterEffect(e2)   
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c10163009.efilter)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_AVAILABLE_BD)
	e4:SetTargetRange(1,0)
	e4:SetValue(0)
	c:RegisterEffect(e4) 
	local e5=e4:Clone()
	e5:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e5) 
	--atk
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10163009,0))
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(c10163009.atkcost)
	e6:SetOperation(c10163009.atkop)
	c:RegisterEffect(e6) 
	--cannot attack
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_ATTACK)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(c10163009.antarget)
	c:RegisterEffect(e8)
end
function c10163009.antarget(e,c)
	return c~=e:GetHandler()
end
function c10163009.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9333) and c:IsAbleToRemoveAsCost()
end
function c10163009.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10163009.rmfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10163009.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_COST)~=0 then
	   e:SetLabel(g:GetFirst():GetAttack())
	end
end
function c10163009.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(e:GetLabel()*2)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		c:RegisterEffect(e1)
	end
end
function c10163009.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c10163009.sprfilter1(c)
	return c:IsSetCard(0x9333) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c10163009.sprfilter2(c,tp,g1)
	return c:IsRace(RACE_DRAGON)
		and g1:IsExists(Card.IsRace,1,c,RACE_WYRM)
end
function c10163009.spcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<-4 then return false end
	local g1=Duel.GetMatchingGroup(c10163009.sprfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local g2=g1:Filter(c10163009.sprfilter2,nil,tp,g1)
	if g1:GetCount()<5 or g2:GetCount()<=0 then return false end
	if ft>0 then return true 
	else return g1:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE) 
	end
end
function c10163009.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g1=Duel.GetMatchingGroup(c10163009.sprfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local g2=g1:Filter(c10163009.sprfilter2,nil,tp,g1)
	local g3=g1:Filter(Card.IsRace,nil,RACE_WYRM)
	local g=Group.CreateGroup()
	local p1,p2,tc=0,0
	for i=1,5 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		if ft<=0 then
		   if p1==0 and i==4 then
			tc=g2:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE):GetFirst()
		   elseif p2==0 and i==5 then
			tc=g3:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE):GetFirst()
		   else
			tc=g1:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE):GetFirst()
		   end
		else
		   if p1==0 and i==4 then
			tc=g2:Select(tp,1,1,nil):GetFirst()
		   elseif p2==0 and i==5 then
			tc=g3:Select(tp,1,1,nil):GetFirst()
		   else
			tc=g1:Select(tp,1,1,nil):GetFirst()
		   end
		end
		g:AddCard(tc)
		g1:RemoveCard(tc)
		if tc:IsRace(RACE_DRAGON) then
			p1=1
		elseif tc:IsRace(RACE_WYRM) then
			p2=1
		end
		ft=ft+1
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end





