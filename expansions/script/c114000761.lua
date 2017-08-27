--★夢を取り戻す魔法少女 ミンキーモモ
function c114000761.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--p scale up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(114000761,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	--e2:SetCondition(c114000761.pcon)
	e2:SetCost(c114000761.p1cost)
	e2:SetOperation(c114000761.p1op)
	c:RegisterEffect(e2)
	--p scale down
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(114000761,1))
	e3:SetCost(c114000761.p2cost)
	e3:SetOperation(c114000761.p2op)
	c:RegisterEffect(e3)
	--sp summon
	local e4=e2:Clone()
	e4:SetDescription(aux.Stringid(114000761,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCost(c114000761.p3cost)
	e4:SetTarget(c114000761.p3tar)
	e4:SetOperation(c114000761.p3op)
	c:RegisterEffect(e4)
	--atk/def up
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c114000761.atktg)
	e5:SetOperation(c114000761.atkop)
	c:RegisterEffect(e5)
	--no battle damage
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	c:RegisterEffect(e6)
end
--p scale up function
function c114000761.pcon(e)
	local seq=e:GetHandler():GetSequence()
	return seq==6 or seq==7
end
function c114000761.prmfilter(c)
	return c:IsAbleToRemoveAsCost()
end
function c114000761.p1cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114000761.prmfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local ft=Duel.GetMatchingGroupCount(c114000761.prmfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c114000761.prmfilter,tp,LOCATION_GRAVE,0,1,ft,nil)
	e:SetLabel(g:GetCount())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c114000761.p1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_RSCALE)
		e2:SetValue(e:GetLabel())
		e2:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e2)
	end
end
-- p scale down function
function c114000761.p2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetMatchingGroupCount(c114000761.prmfilter,tp,LOCATION_GRAVE,0,nil)
	local c=e:GetHandler()
	local ls=c:GetLeftScale()
	local rs=c:GetRightScale()
	if ls>rs then ls=rs end
	if ft>=ls then ft=ls-1 end --prevent scale 0
	--given if scale=0, no cards can be removed by this way --> false returned
	if chk==0 then 
	return Duel.IsExistingMatchingCard(c114000761.prmfilter,tp,LOCATION_GRAVE,0,1,nil)
	and ls>1 end -- if scale==1, false returned
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c114000761.prmfilter,tp,LOCATION_GRAVE,0,1,ft,nil)
	e:SetLabel(g:GetCount())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c114000761.p2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local q=e:GetLabel()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		e1:SetValue(-q)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_RSCALE)
		e2:SetValue(-q)
		e2:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e2)
	end
end
--sp summon p function
function c114000761.spfilter(c,e,tp)
	return c:IsSetCard(0x221) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c114000761.p3cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetMatchingGroupCount(c114000761.prmfilter,tp,LOCATION_GRAVE,0,nil)
	local sg=Duel.GetMatchingGroup(c114000761.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	local lv=13
	--determine minimum level on hand
	--return false if no monster on hand
	if sg:GetCount()==0 then return false end
	while sg:GetCount()>=1 do
		local tc=sg:GetFirst()
		sg:RemoveCard(tc)
		local mlv=tc:GetLevel()
		if lv>mlv then lv=mlv end
	end
	-- return false if too few to remove
	local lvcap=ft*2
	if lvcap<lv then return false end
	-- otherwise return true
	if chk==0 then 
	return true end --Duel.IsExistingMatchingCard(c114000761.prmfilter,tp,LOCATION_GRAVE,0,1,nil)
	local bound=lv/2
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c114000761.prmfilter,tp,LOCATION_GRAVE,0,bound,ft,nil)
	e:SetLabel(g:GetCount())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c114000761.p3tar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c114000761.p3op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end --field existance check
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local slv=e:GetLabel()*2
	local sg=Duel.GetMatchingGroup(c114000761.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	sg:Remove(Card.IsLevelAbove,nil,slv+1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=sg:Select(tp,1,1,nil):GetFirst()
	if g~=nil then
		Duel.SpecialSummon(g,201,tp,tp,false,false,POS_FACEUP)
	end
end
--atk/def up function
function c114000761.rmfilter(c)
	return c:IsSetCard(0x221) and c:IsAbleToRemoveAsCost()
end
function c114000761.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114000761.rmfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c114000761.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetMatchingGroupCount(c114000761.rmfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,c114000761.rmfilter,tp,LOCATION_GRAVE,0,1,ft,nil)
	local ct=Duel.Remove(cg,POS_FACEUP,REASON_EFFECT)
	if ct>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*800)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end